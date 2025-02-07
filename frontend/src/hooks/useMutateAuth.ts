import { useMutation } from '@tanstack/react-query'
import axios, { AxiosResponse } from 'axios'
import { useNavigate } from 'react-router-dom'
import { useError } from '../hooks/useError'
import useStore from '../store'
import { Credential } from '../types'

export const useMutateAuth = () => {
  const navigate = useNavigate()
  const { switchErrorHandling } = useError()
  const { setIsLogin } = useStore((state) => ({
    setIsLogin: state.setIsLogin,
  }))

  const loginMutation = useMutation<AxiosResponse<any>, Error, Credential>({
    mutationFn: async (user) => {
      return await axios.post(`${import.meta.env.VITE_API_URL}/login`, user)
    },
    onSuccess: () => {
      setIsLogin(true)
      navigate('/generate')
    },
    onError: (err: any) => {
      if (err.response?.data?.message) {
        switchErrorHandling(err.response.data.message)
      } else {
        switchErrorHandling(err.response?.data || 'ログインに失敗しました')
      }
    },
  })

  const registerMutation = useMutation<AxiosResponse<any>, Error, Credential>({
    mutationFn: async (user) => {
      return await axios.post(`${import.meta.env.VITE_API_URL}/signup`, user)
    },
    onError: (err: any) => {
      if (err.response?.data?.message) {
        switchErrorHandling(err.response.data.message)
      } else {
        switchErrorHandling(err.response?.data || '登録に失敗しました')
      }
    },
  })

  const logoutMutation = useMutation<AxiosResponse<any>, Error, void>({
    mutationFn: async () => {
      return await axios.post(`${import.meta.env.VITE_API_URL}/logout`)
    },
    onSuccess: () => {
      setIsLogin(false)
      navigate('/')
    },
    onError: (err: any) => {
      if (err.response?.data?.message) {
        switchErrorHandling(err.response.data.message)
      } else {
        switchErrorHandling(err.response?.data || 'ログアウトに失敗しました')
      }
    },
  })

  return { loginMutation, registerMutation, logoutMutation }
}
