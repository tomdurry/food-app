import { useError } from '@/hooks/useError'
import { Recipe } from '@/types'
import { useQuery } from '@tanstack/react-query'
import axios from 'axios'

export const useQueryRecipes = () => {
  const { switchErrorHandling } = useError()

  const getRecipes = async (): Promise<Recipe[]> => {
    const { data } = await axios.get<Recipe[]>(
      `${import.meta.env.VITE_API_URL}/recipes`,
      { withCredentials: true }
    )
    return data
  }

  const query = useQuery<Recipe[], Error>({
    queryKey: ['recipes'] as const,
    queryFn: getRecipes,
    staleTime: Infinity,
  })

  if (query.error) {
    if (query.error instanceof Error && 'response' in query.error) {
      const axiosError = query.error as any
      switchErrorHandling(
        axiosError.response?.data?.message || 'データ取得に失敗しました'
      )
    } else {
      switchErrorHandling('データ取得に失敗しました')
    }
  }

  return query
}
