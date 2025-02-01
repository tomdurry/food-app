import axios from 'axios'
import { useNavigate } from 'react-router-dom'
import { CsrfToken } from '../types'

export const useError = () => {
  const navigate = useNavigate()
  const getCsrfToken = async () => {
    const { data } = await axios.get<CsrfToken>(
      `${import.meta.env.VITE_API_URL}/csrf`
    )
    axios.defaults.headers.common['X-CSRF-TOKEN'] = data.csrf_token
  }
  const switchErrorHandling = (msg: string) => {
    switch (msg) {
      case 'invalid csrf token':
        getCsrfToken()
        alert('CSRF token is invalid, please try again')
        break
      case 'invalid or expired jwt':
        alert('access token expired, please login')
        navigate('/')
        break
      case 'missing or malformed jwt':
        alert('access token is not valid, please login')
        navigate('/')
        break
      case 'crypto/bcrypt: hashedPassword is not the hash of the given password':
        alert('ログインIDまたはパスワードが正しくありません。')
        break
      case 'record not found':
        alert('ログインIDまたはパスワードが正しくありません。')
        break
      case 'ERROR: duplicate key value violates unique constraint "uni_users_login_id" (SQLSTATE 23505)':
        alert(
          '入力されたユーザーIDは既に存在します。他のユーザーIDを利用してください。'
        )
        break
      default:
        alert(msg)
    }
  }

  return { switchErrorHandling }
}
