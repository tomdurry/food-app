from fastapi import FastAPI
from pydantic import BaseModel, Field
from typing import List
from openai import OpenAI
import json
import requests
import boto3
from datetime import datetime
import os
import logging
import traceback

# AWS設定
AWS_REGION = os.getenv("AWS_REGION", "ap-northeast-1")
S3_BUCKET_NAME = os.getenv("S3_BUCKET_NAME", "food-app-racipe-image-prod")

# クライアント初期化
client = OpenAI()
s3_client = boto3.client("s3", region_name=AWS_REGION)

# ログ設定
boto3.set_stream_logger('boto3', level=logging.DEBUG)
logging.basicConfig(level=logging.DEBUG)
logger = logging.getLogger("uvicorn")

# データモデル
class Ingredient(BaseModel):
    ingredient: str
    quantity: str

class RecipeRequest(BaseModel):
    ingredients: List[Ingredient]
    cooking_time: str
    taste: str

class Recipe(BaseModel):
    ingredients: list[Ingredient]
    instructions: list[str] = Field(
        description="手順", examples=[["材料を切ります。", "材料を炒めます。"]]
    )
    recipe_name: str = Field(description="料理名", example="チキンの炒め物")
    image_url: str = Field(description="レシピのイメージ画像URL", example="https://example.com/image.png")

OUTPUT_RECIPE_FUNCTION = [
    {
        "type": "function",
        "function": {
            "name": "output_recipe",
            "description": "レシピを出力する",
            "parameters": Recipe.schema(),
        }
    }
]

app = FastAPI()

@app.post("/generate-recipe")
async def generate_recipe(recipe_request: RecipeRequest):

    # プロンプト生成
    prompt = f"以下の材料があります:\n"
    for ingredient in recipe_request.ingredients:
        prompt += f"- {ingredient.ingredient} ({ingredient.quantity})\n"
    prompt += f"\n調理時間: {recipe_request.cooking_time}\n"
    prompt += f"味のテイスト: {recipe_request.taste}\n"
    prompt += "これらの材料を使って、何かおいしい料理を提案してください。"

    # OpenAIリクエスト
    response = client.chat.completions.create(
        model="gpt-4o",
        messages=[{"role": "user", "content": prompt}],
        tools=OUTPUT_RECIPE_FUNCTION,
        tool_choice="auto",
        max_tokens=2000,
    )

    function_call_args = None

    if response.choices[0].finish_reason == 'tool_calls':
        response_message = response.choices[0].message
        function_call_args = response_message.tool_calls[0].function.arguments

    recipe = json.loads(function_call_args)

    # DALL·Eプロンプト生成
    dalle_prompt = f"Create an image of the dish named '{recipe['recipe_name']}' with the following ingredients: "
    for ingredient in recipe['ingredients']:
        dalle_prompt += f"{ingredient['ingredient']} ({ingredient['quantity']}), "
    dalle_prompt = dalle_prompt.rstrip(", ") + "."

    logger.debug(f"DALL·E prompt: {dalle_prompt}")

    # DALL·E APIリクエスト
    dalle_response = client.images.generate(
        model="dall-e-3",
        prompt=dalle_prompt,
        size="1024x1024",
        quality="standard",
        n=1,
    )

    dalle_image_url = dalle_response.data[0].url
    image_data = requests.get(dalle_image_url).content

    current_date = datetime.now().strftime("%Y/%m/%d")
    s3_key = f"{current_date}/recipes/{recipe['recipe_name'].replace(' ', '_')}.png"

    try:
        # データ検証
        if not image_data:
            logger.error("Image data is empty or invalid.")
            return {"error": "Image data is empty or invalid."}

        if not S3_BUCKET_NAME:
            logger.error("S3_BUCKET_NAME is not set.")
            return {"error": "S3_BUCKET_NAME is not configured."}

        if not s3_key:
            logger.error("S3 key is invalid.")
            return {"error": "S3 key generation failed."}

        # S3アップロード
        response = s3_client.put_object(
            Bucket=S3_BUCKET_NAME,
            Key=s3_key,
            Body=image_data,
            ContentType="image/png"
        )
        logger.debug(f"S3 upload response: {response}")

        s3_url = f"https://{S3_BUCKET_NAME}.s3.amazonaws.com/{s3_key}"
        recipe['image_url'] = s3_url

    except Exception as e:
        error_trace = traceback.format_exc()
        logger.error(f"Failed to upload to S3. Error: {str(e)}")
        logger.error(f"Traceback: {error_trace}")
        return {"error": f"Failed to upload to S3: {str(e)}"}

    return {"recipe": recipe}

# AWS Lambdaハンドラー
def lambda_handler(event, context):
    from mangum import Mangum
    handler = Mangum(app)
    return handler(event, context)
