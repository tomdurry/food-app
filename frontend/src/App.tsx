import { useEffect, useState } from 'react';
import { BrowserRouter, Route, Routes } from 'react-router-dom';
import { NavigationBar } from './components/NavigationBar';
import { Auth } from './components/Auth';
import { InputIngredients } from './components/InputIngredients';
import { DisplayRecipe } from './components/DisplayRecipe';
import axios from 'axios';
import { CsrfToken, Recipe } from './types';

function App() {
  const [recipe, setRecipe] = useState<Recipe | null>(null);
  const [loading, setLoading] = useState(false);

  useEffect(() => {
    axios.defaults.withCredentials = true;
    const getCsrfToken = async () => {
      const { data } = await axios.get<CsrfToken>(
        `${process.env.REACT_APP_API_URL}/csrf`
      );
      axios.defaults.headers.common['X-CSRF-Token'] = data.csrf_token;
    };
    getCsrfToken();
  }, []);

  return (
    <BrowserRouter>
      <NavigationBar />
      <div className="pt-16">
        <Routes>
          <Route path="/" element={<Auth />} />
          <Route 
            path="/generate" 
            element={<InputIngredients setRecipe={setRecipe} setLoading={setLoading} loading={loading} />} 
          />
          {recipe && <Route path="/recipe" element={<DisplayRecipe recipe={recipe} />} />}
        </Routes>
      </div>
    </BrowserRouter>
  );
}

export default App;
