// NavigationBar.test.tsx

import { NavigationBar } from '@/components/NavigationBar'
import useStore from '@/store'
import { fireEvent, render, screen, waitFor } from '@testing-library/react'
import { BrowserRouter } from 'react-router-dom'
import { vi } from 'vitest'

vi.mock('@/hooks/useMutateAuth', () => ({
  useMutateAuth: () => ({
    logoutMutation: {
      mutateAsync: vi.fn(),
    },
  }),
}))

const mockSetIsLoginForm = vi.fn()

vi.mock('@/store', () => ({
  __esModule: true,
  default: vi.fn(() => ({
    isLogin: false,
    setIsLoginForm: mockSetIsLoginForm,
  })),
}))

describe('NavigationBar', () => {
  beforeEach(() => {
    vi.clearAllMocks()
  })

  it('Login and user registration buttons appear when not logged in', () => {
    render(
      <BrowserRouter>
        <NavigationBar />
      </BrowserRouter>
    )

    expect(screen.getByText('ログイン')).toBeInTheDocument()
    expect(screen.getByText('ユーザー登録')).toBeInTheDocument()
  })

  it('Clicking the login button takes you to the authentication page.', async () => {
    render(
      <BrowserRouter>
        <NavigationBar />
      </BrowserRouter>
    )
    const loginButton = await waitFor(() => screen.getByTestId('login-button'))

    fireEvent.click(loginButton)

    expect(mockSetIsLoginForm).toHaveBeenCalledWith(true)
  })

  it('When logged in, the favorite and logout buttons are displayed', () => {
    ;(useStore as vi.Mock).mockReturnValue({
      isLogin: true,
      setIsLoginForm: mockSetIsLoginForm,
    })

    render(
      <BrowserRouter>
        <NavigationBar />
      </BrowserRouter>
    )

    expect(screen.getByText('お気に入りレシピ')).toBeInTheDocument()
    expect(screen.getByText('ログアウト')).toBeInTheDocument()
  })

  it('Clicking the logout button calls the logout process', async () => {
    const mockLogoutMutation = vi.fn()
    ;(useStore as vi.Mock).mockReturnValue({
      isLogin: true,
      setIsLoginForm: mockSetIsLoginForm,
    })

    render(
      <BrowserRouter>
        <NavigationBar />
      </BrowserRouter>
    )

    const logoutButton = await screen.findByText('ログアウト')
    fireEvent.click(logoutButton)

    expect(mockLogoutMutation).not.toHaveBeenCalled()
  })
})
