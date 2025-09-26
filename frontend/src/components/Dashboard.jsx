import React from "react";
import { useLocation, useNavigate } from "react-router-dom";
import Swal from "sweetalert2";

import Tecnologia from './Tecnologia'
import RecursosHumanos from "./RecursosHumanos"
import Almacen from "./Almacen"
import Ventas from "./Ventas"
import Finanzas from "./Finanzas"
import Soportes from "./Soportes"

const Dashboard = () => {
  const location = useLocation();
  const navigate = useNavigate();
  const { usuario } = location.state || {};

  // FUNCION PARA MANEJAR EL CIERRE DE SESION
  const handleLogout = () => {
    Swal.fire({
      icon: 'warning',
      title: '¿Estás seguro?',
      text: 'Quieres cerrar sesión',
      showCancelButton: true,
      confirmButtonText: 'Sí, cerrar sesión',
      cancelButtonText: 'Cancelar'
    }).then((result) => {
      if (result.isConfirmed) {
        Swal.fire({
          icon: 'success',
          title: 'Hasta luego',
          text: 'Gracias por usar la aplicación',
          timer: 2000,
          showConfirmButton: false
        }).then(() => {
          navigate('/login'); // mejor ruta absoluta
        })
      }
    })
  }

  const renderAreaComponent = () => {
    switch(usuario.area){
        case 'tecnologia': return <Tecnologia usuario ={ usuario.usuario } />
        case 'recursos humanos': return <RecursosHumanos />
        case 'almacen': return <Almacen />
        case 'ventas': return <Ventas usuario ={ usuario.usuario } />
        case 'finanzas': return <Finanzas />
        case 'soporte': return <Soportes/>
    }
  }

  return (
    <div>
      {/* BARRA SUPERIOR */}
      <div className="d-flex justify-content-between align-items-center bg-dark text-white p-3">
        <div className="text-center w-100">
          <p className="m-0">{usuario?.nombre}</p>
          <p className="m-0">{usuario?.area}</p>
        </div>
        <button onClick={handleLogout} className="btn btn-danger">
          <i className="bi bi-box-arrow-right"></i>
        </button>
      </div>

      {renderAreaComponent()}
    </div>
  )
}

export default Dashboard;
