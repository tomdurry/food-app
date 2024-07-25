import { create } from 'zustand'

type Recipe = {
  id: number
  recipe_name: string
  ingredients: { ingredient: string; quantity: string }[]
  instructions: string | string[]
  image_url: string
}

type State = {
  Recipe: Recipe
  GenerateRecipe: (payload: Recipe) => void

  isLogin: boolean
  setIsLogin: (isLogin: boolean) => void

  isLoginForm: boolean
  setIsLoginForm: (isLoginForm: boolean) => void
}

const useStore = create<State>((set) => ({
  Recipe: {
    id: 0,
    recipe_name: '',
    ingredients: [],
    instructions: '',
    image_url: '',
  },
  GenerateRecipe: (payload) =>
    set({
      Recipe: payload,
    }),

  isLogin: false,
  isLoginForm: true,

  setIsLogin: (isLogin: boolean) => set({ isLogin: isLogin }),
  setIsLoginForm: (isLoginForm: boolean) => set({ isLoginForm: isLoginForm }),
}))

export default useStore
