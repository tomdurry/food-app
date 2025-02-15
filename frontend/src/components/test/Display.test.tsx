import { Display } from '@/components/Display'
import useStore from '@/store'
import { fireEvent, render, screen } from '@testing-library/react'
import { vi } from 'vitest'

vi.mock('@/store', async (importOriginal) => {
  const actual = await importOriginal<typeof import('@/store')>()
  return {
    ...actual,
    default: vi.fn(() => ({
      Recipe: {
        recipe_name: 'テストレシピ',
        ingredients: [
          { ingredient: '卵', quantity: '2個' },
          { ingredient: '牛乳', quantity: '200ml' },
        ],
        instructions: ['卵を割る', '牛乳と混ぜる', '焼く'],
        image_url: 'https://example.com/image.jpg',
      },
      isLogin: true,
    })),
  }
})

vi.mock('@/hooks/useMutateRecipe', () => ({
  useMutateRecipe: vi.fn(() => ({
    favoriteMutation: {
      mutate: vi.fn(),
    },
  })),
}))

describe('Display コンポーネント', () => {
  it('Recipe is displayed correctly', () => {
    render(<Display />)

    expect(screen.getByText('生成されたレシピ')).toBeInTheDocument()
    expect(screen.getByText('テストレシピ')).toBeInTheDocument()
    expect(screen.getByText('卵 - 2個')).toBeInTheDocument()
    expect(screen.getByText('牛乳 - 200ml')).toBeInTheDocument()
    expect(screen.getByText('1. 卵を割る')).toBeInTheDocument()
    expect(screen.getByText('2. 牛乳と混ぜる')).toBeInTheDocument()
    expect(screen.getByText('3. 焼く')).toBeInTheDocument()

    const image = screen.getByRole('img')
    expect(image).toHaveAttribute('src', 'https://example.com/image.jpg')
    expect(image).toHaveAttribute('alt', 'テストレシピ')
  })

  it('The favorites button functions properly', () => {
    render(<Display />)
    const favoriteButton = screen.getByRole('button', {
      name: 'お気に入りに追加',
    })
    expect(favoriteButton).toBeInTheDocument()
    expect(favoriteButton).toHaveTextContent('お気に入りに追加')
    fireEvent.click(favoriteButton)

    expect(favoriteButton).toHaveTextContent('お気に入りに追加済み')
  })

  it('Display if recipe is not available', () => {
    ;(useStore as unknown as jest.Mock).mockReturnValueOnce({
      Recipe: null,
      isLogin: true,
    })

    render(<Display />)
    expect(
      screen.getByText('レシピがまだ生成されていません。')
    ).toBeInTheDocument()
  })
})
