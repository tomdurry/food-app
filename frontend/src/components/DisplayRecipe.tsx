import React from "react";

interface Recipe {
  recipe_name: string;
  ingredients: { ingredient: string; quantity: string }[];
  instructions: string | string[];
  image_url: string;
}

interface DisplayRecipeProps {
  recipe: Recipe;
}

export function DisplayRecipe({ recipe }: DisplayRecipeProps) {
  return (
    <div className="max-w-3xl mx-auto mt-10 p-6 bg-white rounded-lg shadow-md">
      <h2 className="text-2xl font-bold mb-6 text-center">生成されたレシピ</h2>
      <h3 className="text-xl font-semibold mb-4">{recipe.recipe_name}</h3>
      
      <div className="mb-6">
        <h4 className="text-lg font-semibold mb-2">材料:</h4>
        <ul className="list-disc list-inside">
          {recipe.ingredients.map((ingredient, index) => (
            <li key={index} className="mb-1">{ingredient.ingredient} - {ingredient.quantity}</li>
          ))}
        </ul>
      </div>

      <div className="mb-6">
        <h4 className="text-lg font-semibold mb-2">手順:</h4>
        <div className="pl-4">
          {Array.isArray(recipe.instructions) ? (
            recipe.instructions.map((instruction, index) => (
              <p key={index} className="mb-2">{index + 1}. {instruction}</p>
            ))
          ) : (
            recipe.instructions.split('\n').map((instruction, index) => (
              <p key={index} className="mb-2">{index + 1}. {instruction}</p>
            ))
          )}
        </div>
      </div>

      {recipe.image_url && (
        <div className="mt-6">
          <img src={recipe.image_url} alt={recipe.recipe_name} className="w-full h-auto rounded-lg shadow-md" />
        </div>
      )}
    </div>
  );
}
