import logo from './logo.svg';
import './App.css';
import React, { useEffect, useState } from 'react';
import { BrowserRouter, Route, Routes, Navigate } from 'react-router-dom';
import Login from './components/Login';
import 'bootstrap/dist/css/bootstrap.min.css';
import Permisos from './components/Permisos';
import NuevoPermiso from './components/NuevoPermiso';
import Inicio from './components/Inicio';
import AvisoPrivacidad from './components/AvisoPrivacidad';

function App() {
  // Estado para controlar si el usuario está autenticado
  const [isLoggedIn, setIsLoggedIn] = useState(false);

  return (
    <BrowserRouter>
      <Routes>
        {/* Ruta de inicio de sesión */}
        <Route path='/' element={<Login setIsLoggedIn={setIsLoggedIn} />} />

        {/* Ruta protegida de carrusel */}
        <Route
          path='/homeori'
          element={isLoggedIn ? <Inicio /> : <Navigate to="/" />}
        />

        {/* Ruta protegida de inicio */}
        <Route
          path='/home'
          element={isLoggedIn ? <Permisos /> : <Navigate to="/" />}
        />

        {/* Ruta protegida de inicio */}
        <Route
          path='/permisos'
          element={isLoggedIn ? <Permisos /> : <Navigate to="/" />}
        />

        {/* Ruta protegida para crear nuevo permiso */}
        <Route
          path='/permiso/nuevo/:id?'
          element={isLoggedIn ? <NuevoPermiso /> : <Navigate to="/" />}
        />

        {/* Redireccionar cualquier otra ruta a la página de inicio de sesión */}
        <Route path='/*' element={<Navigate to="/" />} />
        
        {/* Ruta de Aviso de privacidad */}
        {/* <Route
          path='/aviso' element={isLoggedIn ? <AvisoPrivacidad /> : <Navigate to="/" />}
        /> */}
        <Route path='/aviso' Component={AvisoPrivacidad} > </Route>
      </Routes>
      
    </BrowserRouter>
  );
}


export default App;

