import App from '@/App'
import { Auth } from '@/components/Auth'
import { Display } from '@/components/Display'
import { Favorite } from '@/components/Favorite'
import { Generate } from '@/components/Generate'
import { PrivateRoute } from '@/components/PrivateRoute'
import { QueryClient, QueryClientProvider } from '@tanstack/react-query'
import { render, screen, waitFor } from '@testing-library/react'
import axios from 'axios'
import { MemoryRouter, Route, Routes } from 'react-router-dom'
import { vi } from 'vitest'

vi.mock('axios')
const mockedAxios = axios as jest.Mocked<typeof axios>

const queryClient = new QueryClient()

vi.mock('@/store', () => ({
  default: vi.fn(() => ({
    isLogin: true,
  })),
}))

describe('App Component', () => {
  test('Fetches CSRF token on mount', async () => {
    mockedAxios.get.mockResolvedValue({
      data: { csrf_token: 'mocked_csrf_token' },
    })

    render(
      <MemoryRouter initialEntries={['/']}>
        <QueryClientProvider client={queryClient}>
          <App />
        </QueryClientProvider>
      </MemoryRouter>
    )

    await waitFor(() => {
      expect(mockedAxios.get).toHaveBeenCalledWith(
        `${import.meta.env.VITE_API_URL}/csrf`
      )
    })
  })

  test('Displays the navigation bar', () => {
    render(
      <MemoryRouter initialEntries={['/']}>
        <QueryClientProvider client={queryClient}>
          <App />
        </QueryClientProvider>
      </MemoryRouter>
    )
    expect(screen.getByText(/みんなの食卓/i)).toBeInTheDocument()
  })

  test('Displays Generate component at "/"', () => {
    render(
      <MemoryRouter initialEntries={['/']}>
        <QueryClientProvider client={queryClient}>
          <Routes>
            <Route path="/" element={<Generate />} />
          </Routes>
        </QueryClientProvider>
      </MemoryRouter>
    )
    expect(screen.getByText(/AIでレシピを生成/i)).toBeInTheDocument()
  })

  test('Displays Display component at "/display"', () => {
    render(
      <MemoryRouter initialEntries={['/display']}>
        <QueryClientProvider client={queryClient}>
          <Routes>
            <Route path="/display" element={<Display />} />
          </Routes>
        </QueryClientProvider>
      </MemoryRouter>
    )
    expect(
      screen.getByText(/レシピがまだ生成されていません。/i)
    ).toBeInTheDocument()
  })

  test('Displays Auth component at "/auth"', () => {
    render(
      <MemoryRouter initialEntries={['/auth']}>
        <QueryClientProvider client={queryClient}>
          <Routes>
            <Route path="/auth" element={<Auth />} />
          </Routes>
        </QueryClientProvider>
      </MemoryRouter>
    )
    expect(
      screen.getByRole('heading', { name: /ユーザー作成/i })
    ).toBeInTheDocument()
  })

  test('Displays Favorite component at "/favorite" through PrivateRoute', () => {
    render(
      <MemoryRouter initialEntries={['/favorite']}>
        <QueryClientProvider client={queryClient}>
          <Routes>
            <Route
              path="/favorite"
              element={
                <PrivateRoute>
                  <Favorite />
                </PrivateRoute>
              }
            />
          </Routes>
        </QueryClientProvider>
      </MemoryRouter>
    )
    expect(screen.getByText(/ロード中.../i)).toBeInTheDocument()
  })
})
