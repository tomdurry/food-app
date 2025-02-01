import { useMutation, useQueryClient } from '@tanstack/react-query'
import axios from 'axios'
import { Recipe } from '../types'
import { useError } from './useError'

export const useMutateRecipe = () => {
  const queryClient = useQueryClient()
  const { switchErrorHandling } = useError()

  const favoriteMutation = useMutation(
    (recipe: Omit<Recipe, 'id' | 'created_at' | 'updated_at'>) =>
      axios.post<Recipe>(`${import.meta.env.VITE_API_URL}/recipes`, recipe),
    {
      onSuccess: (res) => {
        const previousRecipes = queryClient.getQueryData<Recipe[]>(['recipes'])
        if (previousRecipes) {
          queryClient.setQueryData(['recipes'], [...previousRecipes, res.data])
        }
      },
      onError: (err: any) => {
        if (err.response.data.message) {
          switchErrorHandling(err.response.data.message)
        } else {
          switchErrorHandling(err.response.data)
        }
      },
    }
  )

  const unFavoriteMutation = useMutation(
    (id: number) =>
      axios.delete(`${import.meta.env.VITE_API_URL}/recipes/${id}`),
    {
      onSuccess: (_, variables) => {
        const previousRecipes = queryClient.getQueryData<Recipe[]>(['recipes'])
        if (previousRecipes) {
          queryClient.setQueryData<Recipe[]>(
            ['recipes'],
            previousRecipes.filter((recipe) => recipe.id !== variables)
          )
        }
      },
      onError: (err: any) => {
        if (err.response.data.message) {
          switchErrorHandling(err.response.data.message)
        } else {
          switchErrorHandling(err.response.data)
        }
      },
    }
  )
  return { favoriteMutation, unFavoriteMutation }
}
