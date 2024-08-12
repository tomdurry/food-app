import { useState, FormEvent } from 'react'
import { CheckBadgeIcon } from '@heroicons/react/24/solid'
import { useMutateAuth } from '../hooks/useMutateAuth'
import useStore from '../store'

export const Auth = () => {
  const [email, setEmail] = useState('')
  const [pw, setPw] = useState('')
  const { isLoginForm } = useStore((state) => ({
    isLoginForm: state.isLoginForm,
  }))
  const { loginMutation, registerMutation } = useMutateAuth()

  const submitAuthHandler = async (e: FormEvent<HTMLFormElement>) => {
    e.preventDefault()
    try {
      if (isLoginForm) {
        loginMutation.mutate({
          email: email,
          password: pw,
        })
      } else {
        await registerMutation
          .mutateAsync({
            email: email,
            password: pw,
          })
          .then(() =>
            loginMutation.mutate({
              email: email,
              password: pw,
            })
          )
      }
    } catch (err) {
      console.error('An error occurred during authentication:', err)
    }
  }
  return (
    <div className="flex justify-center items-center flex-col min-h-screen text-gray-600 font-mono">
      <div className="flex items-center mb-8">
        <CheckBadgeIcon className="h-8 w-8 mr-2 text-blue-500" />
        <span className="text-center text-3xl font-extrabold">Login Page</span>
      </div>
      <form onSubmit={submitAuthHandler}>
        <div>
          <input
            className="mb-3 px-3 text-sm py-2 border border-gray-300"
            name="email"
            type="email"
            autoFocus
            placeholder="Email address"
            onChange={(e) => setEmail(e.target.value)}
            value={email}
          />
        </div>
        <div>
          <input
            className="mb-3 px-3 text-sm py-2 border border-gray-300"
            name="password"
            type="password"
            placeholder="Password"
            onChange={(e) => setPw(e.target.value)}
            value={pw}
          />
        </div>
        <div className="flex justify-center my-2">
          <button
            className="disabled:opacity-40 py-2 px-4 rounded text-white bg-indigo-600"
            disabled={!email || !pw}
            type="submit"
          >
            {isLoginForm ? 'ログイン' : 'ユーザー作成'}
          </button>
        </div>
      </form>
    </div>
  )
}
