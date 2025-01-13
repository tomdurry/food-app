export type Recipe = {
  id: number
  recipe_name: string
  ingredients: { ingredient: string; quantity: string }[]
  instructions: string | string[]
  image_url: string
  created_at: Date
  updated_at: Date
}

export type CsrfToken = {
  csrf_token: string
}

export type Credential = {
  loginid: string
  password: string
}
