from fastapi import FastAPI
from pydantic import BaseModel, Field
from typing import List
from openai import OpenAI
import json

client = OpenAI()

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
    prompt = f"以下の材料があります:\n"
    for ingredient in recipe_request.ingredients:
        prompt += f"- {ingredient.ingredient} ({ingredient.quantity})\n"
    prompt += f"\n調理時間: {recipe_request.cooking_time}\n"
    prompt += f"味のテイスト: {recipe_request.taste}\n"
    prompt += "これらの材料を使って、何かおいしい料理を提案してください。"

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

    dalle_prompt = f"Create an image of the dish named '{recipe['recipe_name']}' with the following ingredients: "
    for ingredient in recipe['ingredients']:
        dalle_prompt += f"{ingredient['ingredient']} ({ingredient['quantity']}), "
    dalle_prompt = dalle_prompt.rstrip(", ") + "."
    
    print(f"DALL·E prompt: {dalle_prompt}")
    dalle_response  = client.images.generate(
        model="dall-e-3",
        prompt=dalle_prompt,
        size="1024x1024",
        quality="standard",
        n=1,
        )
    
    recipe['image_url'] = dalle_response.data[0].url

    return {"recipe": recipe}

def lambda_handler(event, context):
    from mangum import Mangum
    handler = Mangum(app)
    return handler(event, context)