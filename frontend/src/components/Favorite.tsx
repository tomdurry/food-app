import { useQueryRecipes } from '../hooks/useQueryRecipes'
import { FavoriteItem } from './FavoriteItem'

export const Favorite = () => {
  const { data, isLoading } = useQueryRecipes()

  return (
    <div className="flex justify-center items-center min-h-screen p-4">
      {isLoading ? (
        <p>Loading...</p>
      ) : (
        <ul className="my-5 grid grid-cols-1 md:grid-cols-2 gap-4">
          {data?.map((recipe) => (
            <FavoriteItem
              key={recipe.id}
              id={recipe.id}
              recipe_name={recipe.recipe_name}
              ingredients={recipe.ingredients}
              instructions={recipe.instructions}
              image_url={recipe.image_url}
            />
          ))}
        </ul>
      )}
    </div>
  )
}
