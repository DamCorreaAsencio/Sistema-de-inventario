import React, { useState } from "react"
import axios from "axios"
import Swal from "sweetalert2"
import { API_ROUTES } from "../api/apiRoutes"

// Ventas.jsx (fragmentos de las capturas)

const Ventas = ({ usuario }) => { // RECIBIMOS USUARIO COMO PROP
    const [codigo, setCodigo] = useState("")
    const [productos, setProductos] = useState([])
    const [cantidadPagada, setCantidadPagada] = useState("")

    // FUNCION PARA MANEJAR EL CAMBIO EN EL INPUT
    const handleCodigoChange = (e) => {
        setCodigo(e.target.value)
    }

    // FUNCION PARA MANEJAR EL CAMBIO EN EL INPUT DE CANTIDAD PAGADA
    const handleCantidadPagadaChange = (e) => {
        setCantidadPagada(e.target.value)
    }

    // FUNCION PARA HACER LA CONSULTA AL BACKEND
    const obtenerProducto = () => {
        // VERIFICAMOS SI EL CAMPO CODIGO ESTA VACIO
        if (!codigo.trim()) {
            Swal.fire({
                icon: 'error',
                title: 'Error',
                text: 'Por favor ingresa un codigo de producto valido'
            })
            return
        }

        // REALIZAR LA SOLICITUD AL BACKEND
        axios.get(API_ROUTES.OBTENER_PRODUCTO_POR_CODIGO(codigo))
            .then(response => {
                if (response.data) {
                    const productosData = Array.isArray(response.data) ? response.data : [response.data]

                    setProductos((prevProductos) => {
                        // VERIFICAMOS SI EL PRODUCTO YA ESTA EN LA LISTA
                        const productoExistente = prevProductos.find(p => p.codigo === productosData[0].codigo)

                        if (productoExistente) {
                            // SI EXISTE, ACTUALIZAMOS LA CANTIDAD
                            return prevProductos.map(p =>
                                p.codigo === productoExistente.codigo ? { ...p, cantidad: p.cantidad + 1 } : p
                            )
                        } else {
                            // SI NO EXISTE, LO AGREGAMOS CON CANTIDAD 1
                            const productoConCantidad = productosData.map(p => ({ ...p, cantidad: 1 }))
                            return [...prevProductos, ...productoConCantidad]
                        }
                    })

                    setCodigo("")
                }
            })
            .catch(err => {
                console.error('Hubo un error al obtener el producto')
            })
    }

    // CALCULAR EL TOTAL DE TODOS LOS PRODUCTOS
    const calcularTotal = () => {
        return productos.reduce((total, producto) => total + (producto.pre_publico * producto.cantidad), 0)
    }

    // FUNCION PARA REGISTRAR LA VENTA
    const registrarVenta = async () => {
        // VERIFICAMOS SI EL CARRITO DE PRODUCTOS ESTA VACIO
        if (productos.length === 0) {
            Swal.fire({
                icon: 'error',
                title: 'Oops...',
                text: 'No hay productos en la venta'
            })
            return
        }

        const total = calcularTotal()

        // VERIFICAMOS SI LA CANTIDAD PAGADA ES VALIDA
        if (!cantidadPagada || isNaN(cantidadPagada) || cantidadPagada <= 0) {
            Swal.fire({
                icon: 'error',
                title: 'Error',
                text: 'Por favor, ingresa una cantidad valida para pagar'
            })
            return
        }

        if (parseFloat(cantidadPagada) < total) {
            Swal.fire({
                icon: 'error',
                title: 'Oops...',
                text: 'La cantidad que el cliente dio es menor al total a pagar'
            })
            return
        }

        // CALCULAR EL CAMBIO SI LA CANTIDAD PAGADA ES MAYOR AL TOTAL
        let cambio = 0
        if (parseFloat(cantidadPagada) > total) {
            cambio = parseFloat(cantidadPagada) - total
        }

        // CODIGO-PRODUCTO-PRE_PUBLICO-CANTIDAD-TOTAL,_TOTALVENTA_USUARIO
        const detallesVenta = productos.map(producto => {
            return `${producto.codigo}-${producto.nom_producto}-${producto.pre_publico}-${producto.cantidad}-${(producto.pre_publico * producto.cantidad)}`
        }).join(',')

        const mensajeVenta = `${detallesVenta}_${total}_${usuario}`
        ///////////////////
        try {
            const response = await axios.post(API_ROUTES.REGISTRAR_VENTA, {
                venta: mensajeVenta
            })

            if (response.status === 201) {
                Swal.fire({
                    icon: 'success',
                    title: `Venta registrada, ID: ${response.data.id_venta}`,
                    text: `${cambio > 0 ? `\nEl cambio es: ${cambio.toFixed(2)}` : ''}`
                })
            }

            setProductos([])
            setCantidadPagada("")
        } catch (err) {
            Swal.fire({
                icon: 'error',
                title: 'Error',
                text: 'Hubo un problema al registrar la venta, intentalo nuevamente'
            })
        }
    }

    return (
        <div className="container mt-4">
            {/* CONTENEDOR QUE ALINEA EL INPUT Y EL BOTON EN LA MISMA LINEA */}
            <div className="d-flex justify-content-center mb-3">
                <input
                    type="text"
                    className="form-control me-2"
                    placeholder="Ingresa el codigo del producto"
                    value={codigo}
                    onChange={handleCodigoChange}
                    style={{ width: "250px" }}
                />
                <button
                    className="btn btn-primary"
                    onClick={obtenerProducto}
                    style={{ height: "calc(2.25rem + 2px)" }}
                >
                    Buscar
                </button>
            </div>

            {/* MOSTRAR PRODUCTOS */}
            <table className="table table-bordered table-striped">
                <thead>
                    <tr className="text-center" style={{ textTransform: 'uppercase' }}>
                        <th>Codigo</th>
                        <th>Producto</th>
                        <th>Precio unidad</th>
                        <th>Cantidad</th>
                        <th>Total</th>
                    </tr>
                </thead>

                <tbody>
                    {productos.map((producto, index) => (
                        <tr key={index}>
                            <td>{producto.codigo}</td>
                            <td>{producto.nom_producto}</td>
                            <td>{producto.pre_publico}</td>
                            <td>{producto.cantidad}</td>
                            <td>{producto.pre_publico * producto.cantidad}</td>
                        </tr>
                    ))}
                </tbody>
            </table>

            {/* MOSTRAR LA FILA CON EL TOTAL AL FINAL DE LA TABLA */}
            <div className="d-flex justify-content-center">
                <h5>Total a pagar: ${calcularTotal()}</h5>
            </div>

            {/* INPUT PARA CAPTURAR LA CANTIDAD QUE EL CLIENTE DA PARA PAGAR */}
            <div className="d-flex justify-content-center mt-3">
                <input
                    type="number"
                    className="form-control me-2"
                    placeholder="Cantidad para pagar"
                    value={cantidadPagada}
                    onChange={handleCantidadPagadaChange}
                    style={{ width: "250px" }}
                />
            </div>

            <div className="d-flex justify-content-center mt-3">
                <button className="btn btn-success" onClick={registrarVenta}>
                    Registrar venta
                </button>
            </div>
        </div>
    )
}

export default Ventas