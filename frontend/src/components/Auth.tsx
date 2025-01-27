import { FormEvent, useState } from 'react'
import { useMutateAuth } from '../hooks/useMutateAuth'
import useStore from '../store'

export const Auth = () => {
  const [login_id, setLoginId] = useState('')
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
          login_id: login_id,
          password: pw,
        })
      } else {
        await registerMutation
          .mutateAsync({
            login_id: login_id,
            password: pw,
          })
          .then(() =>
            loginMutation.mutate({
              login_id: login_id,
              password: pw,
            })
          )
      }
    } catch (err) {
      console.error('An error occurred during authentication:', err)
    }
  }

  return (
    <div className="flex justify-center items-center min-h-screen bg-gradient-to-br from-yellow-100 to-orange-100 font-mono">
      <div className="bg-white p-6 rounded-xl shadow-lg max-w-md w-full">
        <h1 className="text-3xl font-bold text-center text-gray-800 mb-6">
          {isLoginForm ? 'ログイン' : 'ユーザー作成'}
        </h1>
        <form onSubmit={submitAuthHandler}>
          <div className="mb-4">
            <input
              className="w-full px-4 py-3 rounded-lg border border-gray-300 focus:outline-none focus:ring-2 focus:ring-orange-400 text-gray-700"
              name="login_id"
              type="login_id"
              placeholder="ユーザーID"
              autoFocus
              onChange={(e) => setLoginId(e.target.value)}
              value={login_id}
            />
          </div>
          <div className="mb-4">
            <input
              className="w-full px-4 py-3 rounded-lg border border-gray-300 focus:outline-none focus:ring-2 focus:ring-orange-400 text-gray-700"
              name="password"
              type="password"
              placeholder="パスワード"
              onChange={(e) => setPw(e.target.value)}
              value={pw}
            />
          </div>
          <button
            className="w-full py-3 px-4 bg-orange-500 text-white rounded-lg font-semibold text-lg hover:bg-orange-600 focus:outline-none focus:ring-2 focus:ring-orange-400 disabled:opacity-50"
            disabled={!login_id || !pw}
            type="submit"
          >
            {isLoginForm ? 'ログイン' : 'ユーザー作成'}
          </button>
        </form>
        <p className="text-center text-sm text-gray-500 mt-4"></p>
      </div>
    </div>
  )
}
