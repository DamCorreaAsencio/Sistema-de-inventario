import React, { useState } from "react"
import axios from "axios"
import Swal from "sweetalert2"
import { API_ROUTES } from "../api/apiRoutes"

import jsPDF from 'jspdf'
import autoTable from 'jspdf-autotable'

import { Bar } from "react-chartjs-2"
import { Chart as ChartJS, BarElement, CategoryScale, LinearScale, Tooltip, Legend, plugins } from "chart.js"

ChartJS.register(BarElement, CategoryScale, LinearScale, Tooltip, Legend)

const Finanzas = () => {
    const [ventas, setVentas] = useState([])
    const [fechaInicio, setFechaInicio] = useState("")
    const [fechaFin, setFechaFin] = useState("")

    const [modal, setModal] = useState(false)
    const [ventaSeleccionada, setVentaSeleccionada] = useState({})
    const [productosVenta, setProductosVenta] = useState([])

    // MANEJAR LOS CAMBIOS EN EL INPUT DE LA FECHA DE INICIO
    const handleFechaInicioChange = (e) => {
        setFechaInicio(e.target.value)
    }
    // MANEJAR LOS CAMBIOS EN EL INPUT DE LA FECHA DE FIN
    const handleFechaFinChange = (e) => {
        setFechaFin(e.target.value)
    }

    // FUNCION PARA ABRIR EL MODAL
    const verVenta = (venta) => {
        setVentaSeleccionada(venta)
        setModal(true)

        if (typeof venta.productos === "string" && venta.productos.trim() !== "") {
            const productosParseados = venta.productos.split(".").map((producto) => {
                const [codigo, nombre, precio, cantidad, total] = producto.split("-")
                return {
                    codigo,
                    nombre,
                    precio: parseFloat(precio),
                    cantidad: parseInt(cantidad),
                    total: parseFloat(total)
                }
            })

            setProductosVenta(productosParseados)
        } else {
            setProductosVenta([]) // SI NO HAY PRODUCTOS EN EL RANGO
        }
    }
    // FUNCION PARA CERRAR EL MODAL
    const cerrarModal = () => {
        setModal(false)
        setVentaSeleccionada({})
    }

    // FUNCION PARA MOSTRAR LAS VENTAS EN BASE A LAS FECHAS
    const obtenerVentas = () => {
        if (!fechaInicio || !fechaFin) {
            Swal.fire({
                icon: 'error',
                title: 'Error',
                text: 'Por favor selecciona tanto la fecha de inicio como la fecha final.'
            })
            return
        }

        // REALIZA LA SOLICITUD AL BACKEND
        axios.get(API_ROUTES.OBTENER_VENTAS, {
            params: {
                inicio: fechaInicio,
                fin: fechaFin
            }
        })
            .then((response) => {
                setVentas(response.data)
            })
            .catch((err) => {
                Swal.fire({
                    icon: 'error',
                    title: 'Error',
                    text: 'Hubo un problema al obtener las ventas'
                })
            })
    }

    // AGRUPAMOS LAS VENTAS POR FECHA
    const ventasPorDia = ventas.reduce((acc, venta) => {
        const fecha = venta.fecha_venta.split("T")[0]
        acc[fecha] = (acc[fecha] || 0) + venta.total_venta
        return acc
    }, {})

    const data = {
        labels: Object.keys(ventasPorDia),
        datasets: [
            {
                label: "Total de ventas por día",
                data: Object.values(ventasPorDia),
                backgroundColor: "rgba(75,192,192,0.6)",
                borderColor: "rgba(75,192,192,1)",
                borderWidth: 1
            }
        ]
    }

    const options = {
        responsive: true,
        maintainAspectRatio: false,
        plugins: {
            legend: {
                position: "top"
            },
            title: {
                display: true,
                text: "ventas Diarias"
            }
        }
    }

    // FUNCION PARA GENERAR EL PDF
    const generarPDF = () => {
        if (ventas.length === 0) {
            Swal.fire({
                icon: 'info',
                title: 'Sin datos',
                text: 'No hay ventas para exportar en el rango de fechas seleccionado'
            })
            return
        }

        const doc = new jsPDF()
        doc.setFontSize(18)
        doc.text('Reporte de ventas', 14, 22)
        doc.setFontSize(12)
        doc.text(`Desde: ${fechaInicio} - Hasta: ${fechaFin}`, 14, 30)

        let startY = 40

        ventas.forEach((venta, index) => {
            const fecha = venta.fecha_venta.split("T")[0]

            doc.setFontSize(12)
            doc.text(`Venta ID: ${venta.id_venta} | Fecha: ${fecha} | Vendedor: ${venta.vendedor}`, 14, startY)

            startY += 6
            doc.text(`Total venta: $${venta.total_venta.toFixed(2)}`, 14, startY)

            startY += 4

            // PROCESAR PRODUCTOS
            let productos = []
            if (typeof venta.productos === "string" && venta.productos.trim() !== "") {
                productos = venta.productos.split(",").map((producto) => {
                    const [codigo, nombre, precio, cantidad, total] = producto.split("-")
                    return {
                        codigo,
                        nombre,
                        precio: parseFloat(precio),
                        cantidad: parseInt(cantidad),
                        total: parseFloat(total)
                    }
                })
            }

            const productosTabla = productos.map(p => [
                p.codigo,
                p.nombre,
                `$${p.precio.toFixed(2)}`,
                p.cantidad,
                `$${p.total.toFixed(2)}`
            ])

            autoTable(doc, {
                startY: startY + 2,
                head: [["Codigo", "Producto", "Precio", "Cantidad", "Total"]],
                body: productosTabla,
                margin: { left: 14, right: 14 },
                styles: { fontSize: 10 },
                theme: "grid",
                didDrawPage: (data) => {
                    startY = data.cursor.y + 10 // Actualizamos la posicion para la siguiente venta
                }
            })
        })
        doc.save(`reporte_venta_${fechaInicio}_a_${fechaFin}.pdf`)
    }

    return (
        <div>
            {/* CONTENEDOR PARA LAS FECHAS */}
            <div className="d-flex justify-content-center mt-4 mb-4">
                <div className="me-3">
                    <label htmlFor="fechaInicio" className="form-label text-center w-100">Fecha inicial ventas</label>
                    <input
                        id="fechaInicio"
                        type="date"
                        className="form-control"
                        value={fechaInicio}
                        onChange={handleFechaInicioChange}
                        style={{ width: "250px" }}
                    />
                </div>

                <div>
                    <label htmlFor="fechaFin" className="form-label text-center w-100">Fecha final ventas</label>
                    <input
                        id="fechaFin"
                        type="date"
                        className="form-control"
                        value={fechaFin}
                        onChange={handleFechaFinChange}
                        style={{ width: "250px" }}
                    />
                </div>
            </div>

            {/* BOTON PARA OBTENER LAS VENTAS */}
            <div className="d-flex justify-content-center">
                <button
                    className="btn btn-primary me-3"
                    onClick={obtenerVentas}
                >
                    Ver ventas
                </button>

                <button
                    className="btn btn-danger"
                    onClick={generarPDF}
                    disabled={ventas.length === 0}
                >
                    Exportar PDF
                </button>
            </div>

            {/* GRAFICA DE BARRAS */}
            <div className="container mt-4" style={{ width: "100%", maxWidth: "1000px", margin: "0 auto" }}>
                <Bar data={data} options={options} />
            </div>

            {/* MOSTRAR LAS VENTAS OBTENIDAS EN UNA LISTA */}
            <div className="container mt-4">
                {ventas.length > 0 ? (
                    <table className="table table-bordered table-striped">
                        <thead>
                            <tr className="text-center" style={{ textTransform: "uppercase" }}>
                                <th>ID Venta</th>
                                <th>Total Venta</th>
                                <th>Fecha Venta</th>
                                <th>Vendedor</th>
                                <th>Acciones</th>
                            </tr>
                        </thead>

                        <tbody>
                            {ventas.map((venta) => (
                                <tr key={venta.id_venta}>
                                    <td>{venta.id_venta}</td>
                                    <td>{venta.total_venta}</td>
                                    <td>{venta.fecha_venta}</td>
                                    <td>{venta.vendedor}</td>
                                    <td className="text-center">
                                        <button
                                            className="btn btn-warning btn-sm me-2"
                                            onClick={() => verVenta(venta)}
                                        >
                                            <i className="bi bi-pencil-square"></i>
                                        </button>
                                    </td>
                                </tr>
                            ))}
                        </tbody>
                    </table>
                ) : (
                    <p className="text-center">No se encontraron ventas para las fechas seleccionadas</p>
                )}

                {/* MODAL DE VENTA SELECCIONADA */}
                {modal && (
                    <div className="modal show fade d-block" tabIndex="-1">
                        <div className="modal-dialog">
                            <div className="modal-content">
                                <div className="modal-header">
                                    <h5 className="modal-title">Detalles</h5>
                                    <button
                                        type="button"
                                        className="btn-close"
                                        onClick={cerrarModal}>
                                    </button>
                                </div>

                                <div className="modal-body">
                                    <p><strong>ID Venta: </strong> ${ventaSeleccionada.id_venta}</p>
                                    <p><strong>Productos:</strong></p>
                                    <div className="table-responsive">
                                        <table className="table table-sm table-bordered">
                                            <thead className="table-light">
                                                <tr className="text-center" style={{ textTransform: "uppercase" }}>
                                                    <th>Código</th>
                                                    <th>Producto</th>
                                                    <th>Precio unidad</th>
                                                    <th>Cantidad</th>
                                                    <th>Total</th>
                                                </tr>
                                            </thead>

                                            <tbody>
                                                {productosVenta.map((producto, index) => (
                                                    <tr key={index}>
                                                        <td>{producto.codigo}</td>
                                                        <td>{producto.nombre}</td>
                                                        <td>{producto.precio.toFixed(2)}</td>
                                                        <td>{producto.cantidad}</td>
                                                        <td>{producto.total.toFixed(2)}</td>
                                                    </tr>
                                                ))}
                                            </tbody>
                                        </table>
                                    </div>

                                    <p><strong>Total venta: </strong> {ventaSeleccionada.total_venta}</p>
                                    <p><strong>Fecha: </strong>{ventaSeleccionada.fecha_venta?.split("T")[0]}</p>
                                    <p><strong>Vendedor: </strong> {ventaSeleccionada.vendedor}</p>
                                </div>

                                <div className="modal-footer">
                                    <button
                                        className="btn btn-secondary"
                                        onClick={cerrarModal}
                                    >
                                        Cerrar
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                )}
            </div>
        </div>
    )
}
export default Finanzas