export type Recipe = {
  recipe_name: string;
  ingredients: { ingredient: string; quantity: string }[];
  instructions: string | string[];
  image_url: string;
}

export type CsrfToken = {
  csrf_token: string
}

export type Credential = {
  email: string
  password: string
}
