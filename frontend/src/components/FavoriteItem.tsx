import { FC, memo } from 'react'
import { Recipe } from '../types'
import { useMutateRecipe } from '../hooks/useMutateRecipe'

const FavoriteItemMemo: FC<Omit<Recipe, 'created_at' | 'updated_at'>> = ({
  id,
  recipe_name,
  ingredients,
  instructions,
  image_url,
}) => {
  const { unFavoriteMutation } = useMutateRecipe()

  return (
    <li className="relative border border-gray-300 rounded-lg shadow-md overflow-hidden max-w-md mx-auto my-2">
      <img
        src={image_url}
        alt={recipe_name}
        className="w-full h-48 object-cover"
      />
      <div className="p-4 pb-16">
        <h2 className="text-xl font-bold mb-2">{recipe_name}</h2>
        <ul className="list-disc list-inside mb-4">
          {ingredients.map((item, idx) => (
            <li key={idx}>
              {item.ingredient}: {item.quantity}
            </li>
          ))}
        </ul>
        <div>
          {Array.isArray(instructions) ? (
            <ol className="list-decimal list-inside">
              {instructions.map((step, stepIdx) => (
                <li key={stepIdx}>{step}</li>
              ))}
            </ol>
          ) : (
            <p>{instructions}</p>
          )}
        </div>
      </div>
      <button
        onClick={() => {
          unFavoriteMutation.mutate(id)
        }}
        className="absolute left-4 bottom-4 px-4 py-2 bg-red-500 text-white rounded hover:bg-red-700"
      >
        削除
      </button>
    </li>
  )
}
export const FavoriteItem = memo(FavoriteItemMemo)
