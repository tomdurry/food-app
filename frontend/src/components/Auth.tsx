import { useState, FormEvent } from 'react'
import { CheckBadgeIcon } from '@heroicons/react/24/solid'
import { useMutateAuth } from '../hooks/useMutateAuth'
import useStore from '../store'

export const Auth = () => {
  const [loginid, setLoginId] = useState('')
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
          loginid: loginid,
          password: pw,
        })
      } else {
        await registerMutation
          .mutateAsync({
            loginid: loginid,
            password: pw,
          })
          .then(() =>
            loginMutation.mutate({
              loginid: loginid,
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
            name="loginid"
            type="loginid"
            autoFocus
            placeholder="LoginId"
            onChange={(e) => setLoginId(e.target.value)}
            value={loginid}
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
            disabled={!loginid || !pw}
            type="submit"
          >
            {isLoginForm ? 'ログイン' : 'ユーザー作成'}
          </button>
        </div>
      </form>
    </div>
  )
}
