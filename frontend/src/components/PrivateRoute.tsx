import useStore from '@/store'
import { ReactNode } from 'react'
import { Navigate } from 'react-router-dom'

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
