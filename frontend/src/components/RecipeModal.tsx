import { FC } from 'react'
import { Recipe } from '../types'
import { useMutateRecipe } from '../hooks/useMutateRecipe'

interface RecipeModalProps {
  recipe: Recipe
  onClose: () => void
  onDelete: () => void
}

export const RecipeModal: FC<RecipeModalProps> = ({
  recipe,
  onClose,
  onDelete,
}) => {
  const { unFavoriteMutation } = useMutateRecipe()

  const handleDelete = () => {
    unFavoriteMutation.mutate(recipe.id, {
      onSuccess: () => {
        onDelete()
      },
    })
  }

  return (
    <div
      className="fixed inset-0 bg-black bg-opacity-50 flex justify-center items-center z-50 p-6 sm:p-10"
      onClick={onClose}
    >
      <div
        className="bg-white rounded-lg shadow-lg w-10/12 max-w-lg sm:max-w-3xl max-h-[90vh] overflow-y-auto p-8 sm:p-10 relative mt-10 mb-10"
        onClick={(e) => e.stopPropagation()}
      >
        <button
          onClick={onClose}
          className="absolute top-4 right-4 text-gray-500 hover:text-gray-700"
        >
          ✕
        </button>
        <h2 className="text-2xl font-bold text-gray-800 mb-8">
          {recipe.recipe_name}
        </h2>
        <img
          src={recipe.image_url}
          alt={recipe.recipe_name}
          className="w-full h-64 object-cover rounded mb-8"
        />
        <p className="text-lg font-semibold text-gray-700 mb-6">材料:</p>
        <ul className="list-disc list-inside mb-8 text-gray-700 space-y-4">
          {recipe.ingredients.map((item, idx) => (
            <li key={idx}>
              {item.ingredient}: {item.quantity}
            </li>
          ))}
        </ul>
        <p className="text-lg font-semibold text-gray-700 mb-6">手順:</p>
        <div className="text-gray-700 space-y-6">
          {Array.isArray(recipe.instructions) ? (
            recipe.instructions.map((step, idx) => (
              <p key={idx}>
                {idx + 1}. {step}
              </p>
            ))
          ) : (
            <p>{recipe.instructions}</p>
          )}
        </div>
        <button
          onClick={handleDelete}
          className="mt-10 px-6 py-3 bg-red-500 text-white rounded-lg hover:bg-red-600 transition"
        >
          削除
        </button>
      </div>
    </div>
  )
}
