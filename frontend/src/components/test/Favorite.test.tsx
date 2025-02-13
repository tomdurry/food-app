import { Favorite } from '@/components/Favorite'
import { useQueryRecipes } from '@/hooks/useQueryRecipes'
import { Recipe } from '@/types'
import { QueryClient, QueryClientProvider } from '@tanstack/react-query'
import {
  fireEvent,
  render,
  screen,
  waitFor,
  within,
} from '@testing-library/react'
import { BrowserRouter } from 'react-router-dom'
import { beforeEach, describe, expect, it, vi } from 'vitest'

vi.mock('@/hooks/useQueryRecipes')

const mockRecipes: Recipe[] = [
  {
    id: 1,
    recipe_name: 'テストレシピ1',
    image_url: 'https://example.com/image1.jpg',
    ingredients: [
      { ingredient: '塩', quantity: '少々' },
      { ingredient: '水', quantity: '100ml' },
    ],
    instructions: ['手順1', '手順2'],
    created_at: new Date('2024-02-01T12:00:00Z'),
    updated_at: new Date('2024-02-05T15:00:00Z'),
  },
  {
    id: 2,
    recipe_name: 'テストレシピ2',
    image_url: 'https://example.com/image2.jpg',
    ingredients: [{ ingredient: '砂糖', quantity: '50g' }],
    instructions: ['手順A', '手順B'],
    created_at: new Date('2024-02-02T12:00:00Z'),
    updated_at: new Date('2024-02-06T15:00:00Z'),
  },
]

const queryClient = new QueryClient()

describe('Favorite コンポーネント', () => {
  let mockRefetch: vi.Mock

  beforeEach(() => {
    vi.clearAllMocks()
    mockRefetch = vi.fn()
  })

  const renderWithProviders = (ui: JSX.Element) => {
    return render(
      <QueryClientProvider client={queryClient}>
        <BrowserRouter>{ui}</BrowserRouter>
      </QueryClientProvider>
    )
  }

  it('Display during loading.', () => {
    ;(useQueryRecipes as vi.Mock).mockReturnValue({ isLoading: true })
    renderWithProviders(<Favorite />)
    expect(screen.getByText('ロード中...')).toBeInTheDocument()
  })

  it('Correctly display the recipe list', async () => {
    ;(useQueryRecipes as vi.Mock).mockReturnValue({
      data: mockRecipes,
      isLoading: false,
    })
    renderWithProviders(<Favorite />)

    expect(screen.getByText('テストレシピ1')).toBeInTheDocument()
    expect(screen.getByText('テストレシピ2')).toBeInTheDocument()
  })

  it('Click on a recipe to display a modal', async () => {
    ;(useQueryRecipes as vi.Mock).mockReturnValue({
      data: mockRecipes,
      isLoading: false,
    })
    renderWithProviders(<Favorite />)

    fireEvent.click(screen.getByText('テストレシピ1'))

    const modal = screen.getByRole('dialog')
    expect(within(modal).getByText('材料:')).toBeInTheDocument()
    expect(within(modal).getByText('手順:')).toBeInTheDocument()
    expect(within(modal).getByText('テストレシピ1')).toBeInTheDocument()
  })

  it('Close Modal', async () => {
    ;(useQueryRecipes as vi.Mock).mockReturnValue({
      data: mockRecipes,
      isLoading: false,
    })
    renderWithProviders(<Favorite />)

    fireEvent.click(screen.getByText('テストレシピ1'))
    fireEvent.click(screen.getByLabelText('閉じる'))

    await waitFor(() => {
      expect(screen.queryByRole('dialog')).not.toBeInTheDocument()
    })
  })
})
