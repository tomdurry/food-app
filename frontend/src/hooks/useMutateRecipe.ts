import { useMutation, useQueryClient } from '@tanstack/react-query'
import axios, { AxiosResponse } from 'axios'
import { Recipe } from '../types'
import { useError } from './useError'

export const useMutateRecipe = () => {
  const queryClient = useQueryClient()
  const { switchErrorHandling } = useError()

  const favoriteMutation = useMutation<
    AxiosResponse<Recipe>,
    Error,
    Omit<Recipe, 'id' | 'created_at' | 'updated_at'>
  >({
    mutationFn: async (recipe) => {
      return await axios.post<Recipe>(
        `${import.meta.env.VITE_API_URL}/recipes`,
        recipe
      )
    },
    onSuccess: (res) => {
      const previousRecipes = queryClient.getQueryData<Recipe[]>(['recipes'])
      if (previousRecipes) {
        queryClient.setQueryData(['recipes'], [...previousRecipes, res.data])
      }
    },
    onError: (err: any) => {
      if (err.response?.data?.message) {
        switchErrorHandling(err.response.data.message)
      } else {
        switchErrorHandling(
          err.response?.data || 'お気に入り登録に失敗しました'
        )
      }
    },
  })

  const unFavoriteMutation = useMutation<AxiosResponse<any>, Error, number>({
    mutationFn: async (id) => {
      return await axios.delete(`${import.meta.env.VITE_API_URL}/recipes/${id}`)
    },
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
      if (err.response?.data?.message) {
        switchErrorHandling(err.response.data.message)
      } else {
        switchErrorHandling(
          err.response?.data || 'お気に入り解除に失敗しました'
        )
      }
    },
  })

  return { favoriteMutation, unFavoriteMutation }
}
