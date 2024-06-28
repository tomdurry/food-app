import React, { useState } from "react";
import { useNavigate } from "react-router-dom";
import { Recipe } from '../types';

interface GenerateProps {
  setRecipe: (recipe: Recipe) => void;
  setLoading: (loading: boolean) => void;
  loading: boolean;
}

export function InputIngredients({ setRecipe, setLoading, loading }: GenerateProps) {
  const [cookingTime, setCookingTime] = useState("");
  const [taste, setTaste] = useState("");
  const [ingredient, setIngredient] = useState("");
  const [selectedIngredients, setSelectedIngredients] = useState<string[]>([]);
  const [useOnlySelectedIngredients, setUseOnlySelectedIngredients] = useState(false);
  const navigate = useNavigate();

  const handleAddIngredient = () => {
    if (ingredient.trim()) {
      setSelectedIngredients([...selectedIngredients, ingredient]);
      setIngredient("");
    }
  };

  const handleGenerateRecipe = async () => {
    setLoading(true);
    const ingredients = selectedIngredients.map((i) => ({ ingredient: i, quantity: "" }));

    const response = await fetch("https://0bq5egflid.execute-api.ap-northeast-1.amazonaws.com/generate-recipe", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify({
        ingredients,
        cooking_time: cookingTime,
        taste,
        use_only_selected_ingredients: useOnlySelectedIngredients
      }),
    });

    const data = await response.json();
    setRecipe(data.recipe as Recipe);
    setLoading(false);
    navigate("/recipe");  // 生成されたレシピ画面へ遷移
  };

  return (
    <div className="max-w-3xl mx-auto mt-10 p-4 bg-white rounded shadow-md">
      <h1 className="text-2xl font-bold mb-4">AIでレシピを生成</h1>

      <div className="mt-6">
        <label className="block mb-2">① 調理時間 *</label>
        <select
          value={cookingTime}
          onChange={(e) => setCookingTime(e.target.value)}
          className="block w-full p-2 border rounded"
        >
          <option value="">選択してください</option>
          <option value="10分未満">10分未満</option>
          <option value="10-20分">10-20分</option>
          <option value="20-30分">20-30分</option>
          <option value="30分以上">30分以上</option>
        </select>
      </div>

      <div className="mt-6">
        <label className="block mb-2">② オプション *</label>
        <select
          value={taste}
          onChange={(e) => setTaste(e.target.value)}
          className="block w-full p-2 border rounded"
        >
          <option value="">未選択</option>
          <option value="グルテンフリー">グルテンフリー</option>
          <option value="ダイエット向け">ダイエット向け</option>
          <option value="インターナショナル">インターナショナル</option>
          <option value="スタミナ料理">スタミナ料理</option>
          <option value="男飯">男飯</option>
        </select>
      </div>

      <div className="mt-6">
        <label className="block mb-2">③ 使う食材 *</label>
        <div>
          <input
            value={ingredient}
            onChange={(e) => setIngredient(e.target.value)}
            className="block w-full p-2 border rounded mb-2"
            placeholder="食材を入力"
          />
          <button
            onClick={handleAddIngredient}
            className="px-4 py-2 bg-green-500 text-white rounded"
          >
            追加
          </button>
          <div>
            {selectedIngredients.map((ing, index) => (
              <p key={index}>{ing}</p>
            ))}
          </div>
        </div>
      </div>

      <div className="mt-6">
        <label className="block mb-2">
          <input
            type="checkbox"
            checked={useOnlySelectedIngredients}
            onChange={(e) => setUseOnlySelectedIngredients(e.target.checked)}
            className="mr-2"
          />
          指定した食材のみでレシピを生成する
        </label>
      </div>

      <div className="mt-6 text-center">
        <button
          onClick={handleGenerateRecipe}
          className="px-6 py-2 bg-orange-500 text-white font-bold rounded"
          disabled={loading}
        >
          {loading ? "生成中..." : "レシピを生成"}
        </button>
      </div>

      {loading && (
        <div className="mt-6 text-center">
          <p>レシピを生成中です...</p>
        </div>
      )}
    </div>
  );
}
