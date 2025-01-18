import { useEffect } from 'react'
import { BrowserRouter, Route, Routes } from 'react-router-dom'
import { NavigationBar } from './components/NavigationBar'
import { Auth } from './components/Auth'
import { Generate } from './components/Generate'
import { Display } from './components/Display'
import { Favorite } from './components/Favorite'
import { PrivateRoute } from './components/PrivateRoute'
import axios from 'axios'
import { CsrfToken } from './types'

function App() {
  useEffect(() => {
    axios.defaults.withCredentials = true
    const getCsrfToken = async () => {
      const { data } = await axios.get<CsrfToken>(
        `${process.env.REACT_APP_API_URL}/csrf`
      )
      axios.defaults.headers.common['X-CSRF-Token'] = data.csrf_token
    }
    getCsrfToken()
  }, [])

  return (
    <div style={{ backgroundColor: '#FFE6DD', minHeight: '100vh' }}>
      <BrowserRouter>
        <NavigationBar />
        <div className="pt-16">
          <Routes>
            <Route path="/" element={<Generate />} />
            <Route path="/generate" element={<Generate />} />
            <Route path="/display" element={<Display />} />
            <Route path="/auth" element={<Auth />} />
            <Route
              path="/favorite"
              element={
                <PrivateRoute>
                  <Favorite />
                </PrivateRoute>
              }
            />
          </Routes>
        </div>
      </BrowserRouter>
    </div>
  )
}

export default App
