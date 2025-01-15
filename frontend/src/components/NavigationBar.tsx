import { Link, useNavigate } from 'react-router-dom'
import useStore from '../store'
import { useMutateAuth } from '../hooks/useMutateAuth'

export const NavigationBar = () => {
  const { logoutMutation } = useMutateAuth()
  const { isLogin, setIsLoginForm } = useStore((state) => ({
    isLogin: state.isLogin,
    setIsLoginForm: state.setIsLoginForm,
  }))

  const navigate = useNavigate()

  const logout = async () => {
    await logoutMutation.mutateAsync()
  }

  const handleAuthRedirect = (isLoginForm: boolean) => {
    setIsLoginForm(isLoginForm)
    navigate('/auth')
  }

  const handleFavoriteClick = () => {
    if (!isLogin) {
      setIsLoginForm(true)
      navigate('/auth')
    } else {
      navigate('/favorite')
    }
  }

  return (
    <div className="fixed top-0 left-0 w-full bg-orange-500 shadow-md z-10">
      <div className="max-w-7xl mx-auto px-4 py-2 flex justify-between items-center">
        <div className="flex items-center">
          <Link to="/generate" className="text-3xl font-extrabold">
            みんなの食卓
          </Link>
        </div>
        <div className="flex">
          <>
            <Link to="/generate" className="mx-2 text-lg">
              レシピ生成
            </Link>
            {isLogin && (
              <button onClick={handleFavoriteClick} className="mx-2 text-lg">
                お気に入りレシピ
              </button>
            )}
            {isLogin ? (
              <>
                <button onClick={logout} className="mx-2 text-lg">
                  ログアウト
                </button>
              </>
            ) : (
              <>
                <button
                  onClick={() => handleAuthRedirect(true)}
                  className="mx-2 text-lg"
                >
                  ログイン
                </button>
                <button
                  onClick={() => handleAuthRedirect(false)}
                  className="mx-2 text-lg"
                >
                  ユーザー登録
                </button>
              </>
            )}
          </>
        </div>
      </div>
    </div>
  )
}
