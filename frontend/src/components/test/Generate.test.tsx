import { Generate } from '@/components/Generate'
import { fireEvent, render, screen, waitFor } from '@testing-library/react'
import { MemoryRouter } from 'react-router-dom'
import { beforeEach, describe, expect, it, vi } from 'vitest'

const mockGenerateRecipe = vi.fn()

vi.mock('@/store', () => ({
  default: vi.fn(() => ({
    GenerateRecipe: mockGenerateRecipe,
  })),
}))

beforeEach(() => {
  vi.clearAllMocks()
})

describe('Generate Component', () => {
  it('renders the component correctly', () => {
    render(
      <MemoryRouter>
        <Generate />
      </MemoryRouter>
    )

    expect(screen.getByText('AIでレシピを生成')).toBeInTheDocument()
    expect(screen.getByText('① 調理時間')).toBeInTheDocument()
    expect(screen.getByText('② コンセプト')).toBeInTheDocument()
    expect(screen.getByText('③ 使う食材')).toBeInTheDocument()
  })

  it('updates form inputs correctly', () => {
    render(
      <MemoryRouter>
        <Generate />
      </MemoryRouter>
    )

    const cookingTimeSelect = screen.getByLabelText('① 調理時間')
    fireEvent.change(cookingTimeSelect, { target: { value: '10分未満' } })
    expect(cookingTimeSelect).toHaveValue('10分未満')

    const tasteSelect = screen.getByLabelText('② コンセプト')
    fireEvent.change(tasteSelect, { target: { value: 'ダイエット向け' } })
    expect(tasteSelect).toHaveValue('ダイエット向け')

    const ingredientInput =
      screen.getByPlaceholderText('例: にんじん・じゃがいも・玉ねぎ')
    fireEvent.change(ingredientInput, { target: { value: 'にんじん' } })
    expect(ingredientInput).toHaveValue('にんじん')
  })

  it('shows loading state when submitting', async () => {
    global.fetch = vi.fn(
      () =>
        new Promise((resolve) =>
          setTimeout(
            () =>
              resolve({
                json: () => Promise.resolve({ recipe: 'Generated Recipe' }),
              } as Response),
            1000
          )
        )
    ) as unknown as jest.MockedFunction<typeof fetch>

    render(
      <MemoryRouter>
        <Generate />
      </MemoryRouter>
    )

    const ingredientInput =
      screen.getByPlaceholderText('例: にんじん・じゃがいも・玉ねぎ')
    fireEvent.change(ingredientInput, { target: { value: 'にんじん' } })

    const submitButton = screen.getByText('レシピを生成')
    fireEvent.click(submitButton)

    await waitFor(() => screen.getByText('調理中...'))
    expect(screen.getByText('調理中...')).toBeInTheDocument()
  })
})
