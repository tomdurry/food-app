import { ReactNode } from 'react'
import { Navigate } from 'react-router-dom'
import useStore from '../store'

export const PrivateRoute = ({
  children,
}: {
  children: ReactNode
}): JSX.Element => {
  const { isLogin } = useStore((state) => ({
    isLogin: state.isLogin,
  }))
  return isLogin ? <>{children}</> : <Navigate to="/" />
}
