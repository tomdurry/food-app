import { useMutateRecipe } from '@/hooks/useMutateRecipe'
import useStore from '@/store'
import { useState } from 'react'

export const Display = () => {
  const { Recipe, isLogin } = useStore()
  console.log("🔍 Recipe from useStore:", Recipe)
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
    <div className="min-h-screen bg-gradient-to-r from-yellow-100 to-orange-100 flex justify-center items-center font-sans p-4">
      <div className="bg-white shadow-xl rounded-lg p-8 max-w-3xl w-full">
        {Recipe ? (
          <div>
            <div className="flex justify-between items-center mb-6">
              <h2 className="text-3xl font-bold text-gray-800">
                生成されたレシピ
              </h2>
              {isLogin && (
                <button
                  onClick={handleFavoriteClick}
                  className={`px-4 py-2 text-white font-semibold rounded-lg transition ${
                    isFavorite
                      ? 'bg-yellow-400 hover:bg-yellow-500'
                      : 'bg-gray-300 hover:bg-gray-400'
                  }`}
                >
                  {isFavorite ? 'お気に入りに追加済み' : 'お気に入りに追加'}
                </button>
              )}
            </div>
            <h3 className="text-2xl font-semibold text-orange-600 mb-4">
              {Recipe.recipe_name}
            </h3>
            <div className="mb-6">
              <p className="text-lg font-bold text-gray-700 mb-2">材料:</p>
              <ul className="list-disc list-inside space-y-2 text-gray-700">
                {Recipe.ingredients.map((ingredient, index) => (
                  <li key={index}>
                    {ingredient.ingredient} - {ingredient.quantity}
                  </li>
                ))}
              </ul>
            </div>
            <div className="mb-6">
              <p className="text-lg font-bold text-gray-700 mb-2">手順:</p>
              {Array.isArray(Recipe.instructions)
                ? Recipe.instructions.map((instruction, index) => (
                    <p key={index} className="text-gray-700 mb-2">
                      {index + 1}. {instruction}
                    </p>
                  ))
                : Recipe.instructions.split('\n').map((instruction, index) => (
                    <p key={index} className="text-gray-700 mb-2">
                      {index + 1}. {instruction}
                    </p>
                  ))}
            </div>
            {Recipe.image_url && (
              <div className="mt-6">
                <img
                  src={Recipe.image_url}
                  alt={Recipe.recipe_name}
                  className="w-full h-auto rounded-lg shadow-md"
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
    </div>
  )
}
