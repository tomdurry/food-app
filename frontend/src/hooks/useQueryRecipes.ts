import axios from 'axios'
import { useQuery } from '@tanstack/react-query'
import { Recipe } from '../types'
import { useError } from '../hooks/useError'

export const useQueryRecipes = () => {
  const { switchErrorHandling } = useError()
  const getRecipes = async () => {
    const { data } = await axios.get<Recipe[]>(
      `${process.env.REACT_APP_API_URL}/recipes`,
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
