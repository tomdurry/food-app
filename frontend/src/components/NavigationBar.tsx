import { useMutateAuth } from '@/hooks/useMutateAuth'
import useStore from '@/store'
import { useEffect, useRef, useState } from 'react'
import { Link, useNavigate } from 'react-router-dom'

export const NavigationBar = () => {
  const { logoutMutation } = useMutateAuth()
  const { isLogin, setIsLoginForm } = useStore((state) => ({
    isLogin: state.isLogin,
    setIsLoginForm: state.setIsLoginForm,
  }))
  const navigate = useNavigate()
  const [isMenuOpen, setIsMenuOpen] = useState(false)
  const menuRef = useRef<HTMLDivElement>(null)

  const logout = async () => {
    await logoutMutation.mutateAsync()
    setIsMenuOpen(false)
  }

  const handleAuthRedirect = (isLoginForm: boolean) => {
    setIsLoginForm(isLoginForm)
    navigate('/auth')
    setIsMenuOpen(false)
  }

  const handleFavoriteClick = () => {
    if (!isLogin) {
      setIsLoginForm(true)
      navigate('/auth')
    } else {
      navigate('/favorite')
    }
    setIsMenuOpen(false)
  }

  useEffect(() => {
    const handleOutsideClick = (event: MouseEvent) => {
      if (menuRef.current && !menuRef.current.contains(event.target as Node)) {
        setIsMenuOpen(false)
      }
    }

    document.addEventListener('mousedown', handleOutsideClick)
    return () => {
      document.removeEventListener('mousedown', handleOutsideClick)
    }
  }, [])

  return (
    <div className="fixed top-0 left-0 w-full bg-gradient-to-r from-yellow-400 via-orange-400 to-red-400 shadow-lg z-10">
      <div className="max-w-7xl mx-auto px-6 py-4 flex justify-between items-center">
        {/* ブランド名 */}
        <Link
          to="/generate"
          className="text-3xl font-extrabold text-white tracking-wide"
        >
          みんなの食卓
        </Link>

        {/* PC用メニュー */}
        <div className="hidden sm:flex space-x-4">
          <Link
            to="/generate"
            className="text-lg py-2 px-4 rounded-full bg-yellow-500 text-white hover:bg-yellow-600 shadow-lg transition"
          >
            レシピ生成
          </Link>
          {isLogin && (
            <button
              onClick={handleFavoriteClick}
              className="text-lg py-2 px-4 rounded-full bg-green-500 text-white hover:bg-green-600 shadow-lg transition"
            >
              お気に入りレシピ
            </button>
          )}
          {isLogin ? (
            <button
              onClick={logout}
              className="text-lg py-2 px-4 rounded-full bg-red-500 text-white hover:bg-red-600 shadow-lg transition"
            >
              ログアウト
            </button>
          ) : (
            <>
              <button
                onClick={() => handleAuthRedirect(true)}
                className="text-lg py-2 px-4 rounded-full bg-blue-500 text-white hover:bg-blue-600 shadow-lg transition"
              >
                ログイン
              </button>
              <button
                onClick={() => handleAuthRedirect(false)}
                className="text-lg py-2 px-4 rounded-full bg-indigo-500 text-white hover:bg-indigo-600 shadow-lg transition"
              >
                ユーザー登録
              </button>
            </>
          )}
        </div>

        {/* ハンバーガーメニュー（スマホ用） */}
        <div className="sm:hidden relative" ref={menuRef}>
          <button
            onClick={() => setIsMenuOpen(!isMenuOpen)}
            className="text-white text-2xl focus:outline-none"
          >
            ☰
          </button>

          {/* ドロップダウンメニュー */}
          {isMenuOpen && (
            <div className="absolute right-0 mt-2 w-48 bg-white rounded-lg shadow-lg py-0 z-20">
              <Link
                to="/generate"
                onClick={() => setIsMenuOpen(false)}
                className="block px-4 py-2 text-white bg-yellow-500 hover:bg-yellow-600 rounded-t-lg transition"
              >
                レシピ生成
              </Link>
              {isLogin && (
                <button
                  onClick={handleFavoriteClick}
                  className="block w-full text-left px-4 py-2 text-white bg-green-500 hover:bg-green-600 transition"
                >
                  お気に入りレシピ
                </button>
              )}
              {isLogin ? (
                <button
                  onClick={logout}
                  className="block w-full text-left px-4 py-2 text-white bg-red-500 hover:bg-red-600 transition"
                >
                  ログアウト
                </button>
              ) : (
                <>
                  <button
                    onClick={() => handleAuthRedirect(true)}
                    className="block w-full text-left px-4 py-2 text-white bg-blue-500 hover:bg-blue-600 transition"
                  >
                    ログイン
                  </button>
                  <button
                    onClick={() => handleAuthRedirect(false)}
                    className="block w-full text-left px-4 py-2 text-white bg-indigo-500 hover:bg-indigo-600 rounded-b-lg transition"
                  >
                    ユーザー登録
                  </button>
                </>
              )}
            </div>
          )}
        </div>
      </div>
    </div>
  )
}
