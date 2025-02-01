import { useQuery } from '@tanstack/react-query'
import axios from 'axios'
import { useError } from '../hooks/useError'
import { Recipe } from '../types'

export const useQueryRecipes = () => {
  const { switchErrorHandling } = useError()
  const getRecipes = async () => {
    const { data } = await axios.get<Recipe[]>(
      `${import.meta.env.VITE_API_URL}/recipes`,
      { withCredentials: true }
    )
    return data
  }
  return useQuery<Recipe[], Error>({
    queryKey: ['recipes'],
    queryFn: getRecipes,
    staleTime: Infinity,
    onError: (err: any) => {
      if (err.response.data.message) {
        switchErrorHandling(err.response.data.message)
      } else {
        switchErrorHandling(err.response.data)
      }
    },
  })
}
