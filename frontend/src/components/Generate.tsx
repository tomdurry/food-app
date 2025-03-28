import useStore from '@/store'
import { FormEvent, useState } from 'react'
import { useNavigate } from 'react-router-dom'

export const Generate = () => {
  const [cookingTime, setCookingTime] = useState('')
  const [taste, setTaste] = useState('')
  const [ingredient, setIngredient] = useState('')
  const [selectedIngredients] = useState<string[]>([])
  const GenerateRecipe = useStore((state) => state.GenerateRecipe)
  const [loading, setLoading] = useState(false)
  const [useOnlySelectedIngredients, setUseOnlySelectedIngredients] =
    useState(false)
  const navigate = useNavigate()

  const submitGenerateHandler = async (e: FormEvent<HTMLFormElement>) => {
    e.preventDefault()
    setLoading(true)

    const inputIngredients = ingredient
      .split('・')
      .map((ing) => ing.trim())
      .filter((ing) => ing)

    const allIngredients = [...selectedIngredients, ...inputIngredients]

    const ingredients = allIngredients.map((i) => ({
      ingredient: i,
    }))

    const response = await fetch(
      `${import.meta.env.VITE_RECIPE_GENERATE_API_URL}`,
      {
        method: 'POST',
        mode: 'cors',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          ingredients,
          cooking_time: cookingTime,
          taste,
          use_only_selected_ingredients: useOnlySelectedIngredients,
        }),
      }
    )

    const generateData = await response.json()
    const recipeData = generateData.body ? JSON.parse(generateData.body).recipe : generateData.recipe
    GenerateRecipe(recipeData)
    setLoading(false)
    navigate('/display')
  }

  return (
    <div className="min-h-screen bg-gradient-to-r from-yellow-100 to-orange-100 flex justify-center items-center font-sans">
      {loading ? (
        <div className="flex flex-col items-center space-y-4">
          <div className="relative">
            <div className="w-16 h-16 bg-gray-700 rounded-full animate-bounce"></div>
            <div className="absolute top-[-20px] left-6 w-8 h-8 bg-gray-300 rounded-full opacity-50 animate-ping"></div>
            <div className="absolute top-[-40px] left-8 w-6 h-6 bg-gray-300 rounded-full opacity-50 animate-ping"></div>
            <div className="w-20 h-2 bg-gray-500 rounded-full mt-2"></div>
            <p className="mt-4 text-xl font-bold text-gray-800">調理中...</p>
          </div>
        </div>
      ) : (
        <div className="bg-white shadow-lg rounded-xl p-8 w-4/5 max-w-4xl h-4/5 flex flex-col justify-between">
          <h1 className="text-3xl font-bold text-center text-gray-800 mb-10">
            AIでレシピを生成
          </h1>
          <form
            onSubmit={submitGenerateHandler}
            className="flex flex-col flex-grow"
          >
            <div className="mb-10">
              <label
                htmlFor="cookingTime"
                className="block text-sm font-medium text-gray-700 mb-4"
              >
                ① 調理時間
              </label>
              <select
                id="cookingTime"
                value={cookingTime}
                onChange={(e) => setCookingTime(e.target.value)}
                className="block w-full p-4 rounded-lg border border-gray-300 focus:ring-2 focus:ring-orange-400"
              >
                <option value="指定なし">指定なし</option>
                <option value="10分未満">10分未満</option>
                <option value="20分未満">20分未満</option>
                <option value="30分未満">30分未満</option>
              </select>
            </div>

            <div className="mb-10">
              <label
                htmlFor="taste"
                className="block text-sm font-medium text-gray-700 mb-4"
              >
                ② コンセプト
              </label>
              <select
                id="taste"
                value={taste}
                onChange={(e) => setTaste(e.target.value)}
                className="block w-full p-4 rounded-lg border border-gray-300 focus:ring-2 focus:ring-orange-400"
              >
                <option value="">指定なし</option>
                <option value="ダイエット向け">ダイエット向け</option>
                <option value="インターナショナル">インターナショナル</option>
                <option value="日本料理">日本料理</option>
                <option value="スタミナ料理">スタミナ料理</option>
                <option value="男飯">男飯</option>
              </select>
            </div>

            <div className="mb-10">
              <label
                htmlFor="ingredient"
                className="block text-sm font-medium text-gray-700 mb-4"
              >
                ③ 使う食材
              </label>
              <input
                id="ingredient"
                value={ingredient}
                onChange={(e) => setIngredient(e.target.value)}
                className="block w-full p-4 rounded-lg border border-gray-300 focus:ring-2 focus:ring-orange-400"
                placeholder="例: にんじん・じゃがいも・玉ねぎ"
              />
              <div className="mt-6 flex flex-wrap gap-3">
                {selectedIngredients.map((ing, index) => (
                  <span
                    key={index}
                    className="px-4 py-2 bg-orange-200 text-orange-800 rounded-full text-sm"
                  >
                    {ing}
                  </span>
                ))}
              </div>
            </div>

            <div className="mb-10">
              <label className="block text-sm font-medium text-gray-700">
                <input
                  type="checkbox"
                  checked={useOnlySelectedIngredients}
                  onChange={(e) =>
                    setUseOnlySelectedIngredients(e.target.checked)
                  }
                  className="mr-3"
                />
                指定した食材のみでレシピを生成する
              </label>
            </div>

            <div className="text-center">
              <button
                type="submit"
                className="w-full py-4 bg-orange-500 text-white font-bold rounded-lg hover:bg-orange-600 transition disabled:opacity-50"
                disabled={
                  loading ||
                  (ingredient.trim() === '' && selectedIngredients.length === 0)
                }
              >
                レシピを生成
              </button>
            </div>
          </form>
        </div>
      )}
    </div>
  )
}
