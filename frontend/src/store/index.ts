import { create } from 'zustand'

type Recipe = {
  recipe_name: string
  ingredients: { ingredient: string; quantity: string }[]
  instructions: string | string[]
  image_url: string
}

type State = {
  Recipe: Recipe
  GenerateRecipe: (payload: Recipe) => void
  resetGenerateRecipe: () => void

  isLogin: boolean
  setIsLogin: (isLogin: boolean) => void

  isLoginForm: boolean
  setIsLoginForm: (isLoginForm: boolean) => void
}

const useStore = create<State>((set) => ({
  Recipe: {
    recipe_name: '',
    ingredients: [],
    instructions: '',
    image_url: '',
  },
  GenerateRecipe: (payload) =>
    set({
      Recipe: payload,
    }),
  resetGenerateRecipe: () =>
    set({
      Recipe: {
        recipe_name: '',
        ingredients: [],
        instructions: '',
        image_url: '',
      },
    }),

  isLogin: false,
  isLoginForm: true,

  setIsLogin: (isLogin: boolean) => set({ isLogin: isLogin }),
  setIsLoginForm: (isLoginForm: boolean) => set({ isLoginForm: isLoginForm }),
}))

export default useStore
