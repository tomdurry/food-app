import { Auth } from '@/components/Auth'
import { Display } from '@/components/Display'
import { Favorite } from '@/components/Favorite'
import { Generate } from '@/components/Generate'
import { NavigationBar } from '@/components/NavigationBar'
import { PrivateRoute } from '@/components/PrivateRoute'
import { CsrfToken } from '@/types'
import axios from 'axios'
import { useEffect } from 'react'
import { Route, Routes } from 'react-router-dom'

axios.defaults.withCredentials = true

function App() {
  useEffect(() => {
    const getCsrfToken = async () => {
      const { data } = await axios.get<CsrfToken>(
        `${import.meta.env.VITE_API_URL}/csrf`
      )
      axios.defaults.headers.common['X-CSRF-Token'] = data.csrf_token
    }
    getCsrfToken()
  }, [])

  return (
    <div style={{ backgroundColor: '#FFE6DD', minHeight: '100vh' }}>
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
    </div>
  )
}

export default App
