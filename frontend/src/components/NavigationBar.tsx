import { Link } from 'react-router-dom'
import useStore from '../store'
import { useMutateAuth } from '../hooks/useMutateAuth'

export const NavigationBar = () => {
  const { logoutMutation } = useMutateAuth()
  const { isLogin, setIsLoginForm } = useStore((state) => ({
    isLogin: state.isLogin,
    setIsLoginForm: state.setIsLoginForm,
  }))

  const logout = async () => {
    await logoutMutation.mutateAsync()
  }

  return (
    <div className="fixed top-0 left-0 w-full bg-orange-500 shadow-md z-10">
      <div className="max-w-7xl mx-auto px-4 py-2 flex justify-between items-center">
        <div className="flex items-center">
          <Link
            to={isLogin ? '/generate' : '/'}
            className="text-3xl font-extrabold"
          >
            みんなの食卓
          </Link>
        </div>
        <div className="flex">
          <Link to="/generate" className="mx-2 text-lg">
            レシピ生成
          </Link>
          <Link to="/favorite" className="mx-2 text-lg">
            お気に入りレシピ
          </Link>
          {isLogin ? (
            <>
              <button onClick={logout} className="mx-2 text-lg">
                ログアウト
              </button>
            </>
          ) : (
            <>
              <button
                onClick={() => setIsLoginForm(true)}
                className="mx-2 text-lg"
              >
                ログイン
              </button>
              <button
                onClick={() => setIsLoginForm(false)}
                className="mx-2 text-lg"
              >
                ユーザー登録
              </button>
            </>
          )}
        </div>
      </div>
    </div>
  )
}
