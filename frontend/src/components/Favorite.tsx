import { useQueryRecipes } from '../hooks/useQueryRecipes'
import { FavoriteItem } from './FavoriteItem'
import { useState } from 'react'
import { Recipe } from '../types'
import { RecipeModal } from './RecipeModal'

export const Favorite = () => {
  const { data, isLoading, refetch } = useQueryRecipes()
  const [selectedRecipe, setSelectedRecipe] = useState<Recipe | null>(null)

  const handleRecipeClick = (recipe: Recipe) => {
    setSelectedRecipe(recipe)
  }

  const closeModal = () => {
    setSelectedRecipe(null)
  }

  return (
    <div className="min-h-screen bg-gradient-to-br from-yellow-100 to-orange-100 flex flex-col justify-center items-center p-4">
      <div className="w-full max-w-6xl pt-16 pb-4">
        {isLoading ? (
          <div className="flex flex-col items-center justify-center">
            <div className="animate-spin rounded-full h-12 w-12 border-t-4 border-orange-500"></div>
            <p className="mt-4 text-orange-600 text-lg font-semibold">
              ロード中...
            </p>
          </div>
        ) : (
          <ul className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6 w-full">
            {data?.map((recipe) => (
              <FavoriteItem
                key={recipe.id}
                recipe={recipe}
                onClick={() => handleRecipeClick(recipe)}
              />
            ))}
          </ul>
        )}
      </div>

      {selectedRecipe && (
        <RecipeModal
          recipe={selectedRecipe}
          onClose={closeModal}
          onDelete={() => {
            refetch()
            closeModal()
          }}
        />
      )}
    </div>
  )
}
