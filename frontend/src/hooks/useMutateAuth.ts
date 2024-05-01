import axios from 'axios'
import { useNavigate } from 'react-router-dom'
import { useMutation } from '@tanstack/react-query'
import { Credential } from '../types'
import { useError } from '../hooks/useError'
import useStore from '../store'

export const useMutateAuth = () => {
  const navigate = useNavigate()
  const { switchErrorHandling } = useError()
  const { setIsLogin } = useStore((state) => ({
    setIsLogin: state.setIsLogin,
  }))
  const loginMutation = useMutation(
    async (user: Credential) =>
      await axios.post(`${process.env.REACT_APP_API_URL}/login`, user),
    {
      onSuccess: () => {
        setIsLogin(true)
        navigate('/generate')
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
  const registerMutation = useMutation(
    async (user: Credential) =>
      await axios.post(`${process.env.REACT_APP_API_URL}/signup`, user),
    {
      onError: (err: any) => {
        if (err.response.data.message) {
          switchErrorHandling(err.response.data.message)
        } else {
          switchErrorHandling(err.response.data)
        }
      },
    }
  )
  const logoutMutation = useMutation(
    async () => await axios.post(`${process.env.REACT_APP_API_URL}/logout`),
    {
      onSuccess: () => {
        setIsLogin(false)
        navigate('/')
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
  return { loginMutation, registerMutation, logoutMutation }
}