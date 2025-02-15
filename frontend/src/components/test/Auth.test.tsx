import { Auth } from '@/components/Auth'
import { useMutateAuth } from '@/hooks/useMutateAuth'
import useStore from '@/store'
import { fireEvent, render, screen, waitFor } from '@testing-library/react'
import { Mock, beforeEach, describe, expect, it, vi } from 'vitest'

vi.mock('@/hooks/useMutateAuth')
vi.mock('@/store')

describe('Auth Component', () => {
  let loginMutationMock: { mutate: Mock }
  let registerMutationMock: { mutateAsync: Mock }
  let setIsLoginFormMock: Mock

  beforeEach(() => {
    loginMutationMock = { mutate: vi.fn() }
    registerMutationMock = { mutateAsync: vi.fn().mockResolvedValue(undefined) }
    setIsLoginFormMock = vi.fn()
    ;(useMutateAuth as unknown as jest.Mock).mockReturnValue({
      loginMutation: loginMutationMock,
      registerMutation: registerMutationMock,
    })
    ;(useStore as unknown as jest.Mock).mockReturnValue({
      isLoginForm: true,
      setIsLoginForm: setIsLoginFormMock,
    })
  })

  it('renders login form by default', () => {
    render(<Auth />)
    expect(
      screen.getByRole('heading', { name: /ログイン/ })
    ).toBeInTheDocument()
  })

  it('allows user to type in login_id and password fields', async () => {
    render(<Auth />)
    const loginIdInput = screen.getByPlaceholderText(
      'ユーザーID'
    ) as HTMLInputElement
    const passwordInput = screen.getByPlaceholderText(
      'パスワード'
    ) as HTMLInputElement

    fireEvent.change(loginIdInput, { target: { value: 'testuser' } })
    fireEvent.change(passwordInput, { target: { value: 'password123' } })

    await waitFor(() => {
      expect(loginIdInput.value).toBe('testuser')
      expect(passwordInput.value).toBe('password123')
    })
  })

  it('calls loginMutation when submitting login form', async () => {
    render(<Auth />)
    const loginIdInput = screen.getByPlaceholderText(
      'ユーザーID'
    ) as HTMLInputElement
    const passwordInput = screen.getByPlaceholderText(
      'パスワード'
    ) as HTMLInputElement
    const submitButton = screen.getByRole('button', { name: /ログイン/ })

    fireEvent.change(loginIdInput, { target: { value: 'testuser' } })
    fireEvent.change(passwordInput, { target: { value: 'password123' } })
    fireEvent.click(submitButton)

    await waitFor(() => {
      expect(loginMutationMock.mutate).toHaveBeenCalledWith({
        login_id: 'testuser',
        password: 'password123',
      })
    })
  })

  it('calls registerMutation and then loginMutation when submitting register form', async () => {
    ;(useStore as unknown as jest.Mock).mockReturnValue({
      isLoginForm: false,
      setIsLoginForm: setIsLoginFormMock,
    })
    render(<Auth />)
    const loginIdInput = screen.getByPlaceholderText(
      'ユーザーID'
    ) as HTMLInputElement
    const passwordInput = screen.getByPlaceholderText(
      'パスワード'
    ) as HTMLInputElement
    const submitButton = screen.getByRole('button', { name: /ユーザー作成/ })

    fireEvent.change(loginIdInput, { target: { value: 'newuser' } })
    fireEvent.change(passwordInput, { target: { value: 'newpassword' } })
    fireEvent.click(submitButton)

    await waitFor(() => {
      expect(registerMutationMock.mutateAsync).toHaveBeenCalledWith({
        login_id: 'newuser',
        password: 'newpassword',
      })
    })

    await waitFor(() => {
      expect(loginMutationMock.mutate).toHaveBeenCalledWith({
        login_id: 'newuser',
        password: 'newpassword',
      })
    })
  })
})
