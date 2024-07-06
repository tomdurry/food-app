import { useEffect } from 'react'
import { BrowserRouter, Route, Routes } from 'react-router-dom'
import { NavigationBar } from './components/NavigationBar'
import { Auth } from './components/Auth'
import { Generate } from './components/Generate'
import { Display } from './components/Display'
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
    <BrowserRouter>
      <NavigationBar />Ï
      <div className="pt-16">
        <Routes>
          <Route path="/" element={<Auth />} />Ï
          <Route path="/generate" element={<Generate />} />
          <Route path="/display" element={<Display />} />
        </Routes>
      </div>
    </BrowserRouter>
  )
}

export default App
