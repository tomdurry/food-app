import useStore from '../store'
import { useState } from 'react'
import { useMutateRecipe } from '../hooks/useMutateRecipe'

export const Display = () => {
  const { Recipe, isLogin } = useStore() // ログイン状態を取得
  const [isFavorite, setIsFavorite] = useState(false)
  const { favoriteMutation } = useMutateRecipe()

  const handleFavoriteClick = () => {
    if (!isFavorite) {
      favoriteMutation.mutate({
        recipe_name: Recipe.recipe_name,
        ingredients: Recipe.ingredients,
        instructions: Recipe.instructions,
        image_url: Recipe.image_url,
      })
      setIsFavorite(true)
    }
  }

  return (
    <div className="max-w-3xl mx-auto mt-10 p-6 bg-white rounded shadow-md relative">
      {Recipe ? (
        <div>
          <div className="flex justify-between items-center">
            <h2 className="text-2xl font-bold text-gray-800 mb-6">
              生成されたレシピ
            </h2>
            {isLogin && (
              <button
                onClick={handleFavoriteClick}
                className={`p-2 rounded ${
                  isFavorite ? 'bg-yellow-400' : 'bg-gray-200'
                }`}
              >
                {isFavorite ? 'お気に入りに追加済み' : 'お気に入りに追加'}
              </button>
            )}
          </div>
          <h3 className="text-xl font-semibold text-orange-600 mb-4">
            {Recipe.recipe_name}
          </h3>
          <p className="text-lg text-gray-700 mb-4">材料:</p>
          <ul className="list-disc list-inside mb-6 text-gray-700">
            {Recipe.ingredients.map((ingredient, index) => (
              <li key={index} className="mb-2">
                {ingredient.ingredient} - {ingredient.quantity}
              </li>
            ))}
          </ul>
          <p className="text-lg text-gray-700 mb-4">手順:</p>
          {Array.isArray(Recipe.instructions)
            ? Recipe.instructions.map((instruction, index) => (
                <p key={index} className="mb-2 text-gray-700">
                  {index + 1}. {instruction}
                </p>
              ))
            : Recipe.instructions.split('\n').map((instruction, index) => (
                <p key={index} className="mb-2 text-gray-700">
                  {index + 1}. {instruction}
                </p>
              ))}
          {Recipe.image_url && (
            <div className="mt-6">
              <img
                src={Recipe.image_url}
                alt={Recipe.recipe_name}
                className="w-full h-auto rounded"
              />
            </div>
          )}
        </div>
      ) : (
        <p className="text-center text-gray-700">
          レシピがまだ生成されていません。
        </p>
      )}
    </div>
  )
}
