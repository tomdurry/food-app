import { Recipe } from '@/types'
import { FC, memo } from 'react'

interface FavoriteItemProps {
  recipe: Recipe
  onClick: () => void
}

const FavoriteItemMemo: FC<FavoriteItemProps> = ({ recipe, onClick }) => {
  return (
    <li
      onClick={onClick}
      className="relative bg-white border border-gray-300 rounded-lg shadow-md overflow-hidden max-w-md mx-auto my-2 cursor-pointer hover:shadow-lg transition"
    >
      <img
        src={recipe.image_url}
        alt={recipe.recipe_name}
        className="w-full h-48 object-cover"
      />
      <div className="p-4">
        <h2 className="text-xl font-bold mb-2 text-gray-800">
          {recipe.recipe_name}
        </h2>
        <p className="text-sm text-gray-600">
          材料: {recipe.ingredients.length}品
        </p>
      </div>
    </li>
  )
}

export const FavoriteItem = memo(FavoriteItemMemo)
