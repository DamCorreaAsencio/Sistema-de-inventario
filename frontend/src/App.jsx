//import { useState } from 'react'
//import reactLogo from './assets/react.svg'
//import viteLogo from '/vite.svg'
import { BrowserRouter as Router, Routes, Route, Navigate } from 'react-router-dom'
import Login from './components/Login' //En \src\components le ponemos el nombre "Login" a nuestro archivo jxs
import Dashboard from './components/Dashboard.jsx'
import 'bootstrap/dist/css/bootstrap.min.css'
import 'bootstrap-icons/font/bootstrap-icons.css'
//import './App.css'

function App() {
  return (
    <Router>
      <Routes>
        {/* REDIRIGIR LA RUTA RAÍZ A LA RUTA DE LOGIN */}
        <Route path='/' element={<Navigate to="/login" />} />

        {/* RUTA PARA LA PÁGINA DE LOGIN */}
        <Route path='/login' element={<Login />} />

        {/* RUTA PARA EL DASHBOARD DESPUÉS DE LOGUEARSE */}
        <Route path='/dashboard' element={<Dashboard />} />
      </Routes>
    </Router>
  )
}

export default App