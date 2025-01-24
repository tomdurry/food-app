from fastapi import FastAPI
from pydantic import BaseModel, Field
from typing import List
from openai import OpenAI
import json
import requests
import boto3
from datetime import datetime
import os

AWS_REGION = os.getenv("AWS_REGION", "ap-northeast-1")
S3_BUCKET_NAME = os.getenv("S3_BUCKET_NAME", "food-app-racipe-image-prod")

client = OpenAI()
s3_client = boto3.client("s3", region_name=AWS_REGION)


class Ingredient(BaseModel):
    ingredient: str


class RecipeRequest(BaseModel):
    ingredients: List[Ingredient]
    cooking_time: str
    taste: str
    use_only_selected_ingredients: bool = Field(
        default=False, description="指定された食材のみを使用するかどうか"
    )


class RecipeIngredient(BaseModel):
    ingredient: str
    quantity: str


class Recipe(BaseModel):
    ingredients: List[RecipeIngredient]
    instructions: List[str] = Field(
        description="手順", examples=[["材料を切ります。", "材料を炒めます。"]]
    )
    recipe_name: str = Field(description="料理名", example="チキンの炒め物")
    image_url: str = Field(
        description="レシピのイメージ画像URL", example="https://example.com/image.png"
    )


OUTPUT_RECIPE_FUNCTION = [
    {
        "type": "function",
        "function": {
            "name": "output_recipe",
            "description": "レシピを出力する",
            "parameters": Recipe.schema(),
        },
    }
]

app = FastAPI()


@app.post("/generate-recipe")
async def generate_recipe(recipe_request: RecipeRequest):
    prompt = "以下の材料があります:\n"
    for ingredient in recipe_request.ingredients:
        prompt += f"- {ingredient.ingredient}\n"
    prompt += f"\n調理時間: {recipe_request.cooking_time}\n"
    prompt += f"味のテイスト: {recipe_request.taste}\n"

    if recipe_request.use_only_selected_ingredients:
        prompt += "これらの材料のみを使用して、料理を作ってください。\n"
    else:
        prompt += "これらの材料を活用しつつ、他の食材も加えておいしい料理を提案してください。\n"

    response = client.chat.completions.create(
        model="gpt-4o",
        messages=[{"role": "user", "content": prompt}],
        tools=OUTPUT_RECIPE_FUNCTION,
        tool_choice="auto",
        max_tokens=2000,
    )

    function_call_args = None
    if response.choices[0].finish_reason == "tool_calls":
        response_message = response.choices[0].message
        function_call_args = response_message.tool_calls[0].function.arguments

    recipe = json.loads(function_call_args)

    dalle_prompt = (
        f"Create a highly realistic and photo-realistic image of the dish named '{recipe['recipe_name']}' "
        f"with the following ingredients: "
    )
    for ingredient in recipe["ingredients"]:
        dalle_prompt += f"{ingredient['ingredient']} ({ingredient['quantity']}), "
    dalle_prompt = (
        dalle_prompt.rstrip(", ")
        + ". The dish should look freshly cooked, served in a real-life setting, with natural lighting and detailed textures."
    )

    print(f"DALL\u00b7E prompt: {dalle_prompt}")

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
        s3_client.put_object(
            Bucket=S3_BUCKET_NAME, Key=s3_key, Body=image_data, ContentType="image/png"
        )
        s3_url = f"https://{S3_BUCKET_NAME}.s3.amazonaws.com/{s3_key}"
        recipe["image_url"] = s3_url
    except Exception as e:
        return {"error": f"Failed to upload to S3: {str(e)}"}

    return {"recipe": recipe}


def lambda_handler(event, context):
    from mangum import Mangum

    handler = Mangum(app)
    return handler(event, context)
