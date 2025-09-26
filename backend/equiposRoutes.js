const express = require('express')
const router = express.Router()
const db = require('./conexion')

// RUTA PARA OBTENER TODOS LOS ESTADOS DE EQUIPOS
router.get('/estados_equipo', (req, res) => {
    db.query('SELECT * FROM estados_equipo', (err, results) => {
        if (err) {
            return res.status(500).send('Error en la consulta')
        }
        res.json(results)
    })
})

// RUTA PARA OBTENER TODOS LOS EQUIPOS
router.get('/equipos', (req, res) => {
    db.query('SELECT * FROM equipos', (err, results) => {
        if (err) {
            return res.status(500).send('Error en la consulta')
        }
        res.json(results)
    })
})

// RUTA PARA ASIGNAR USUARIO A EQUIPO
router.post('/equipos/asignacion', (req, res) => {
    const { num_serie, usuario } = req.body

    // SI EL USUARIO NO EXISTE O ESTA VACIO, ASIGNAMOS NULL
    const responsable = usuario && usuario.trim() !== '' ? usuario : null

    const query = 'UPDATE equipos SET responsable = ? WHERE num_serie = ?'

    db.query(query, [responsable, num_serie], (err, result) => {
        if (err) {
            console.error('Error al asignar usuario al equipo', err)
            return res.status(500).send('Error al asignar usuario al equipo')
        }

        res.status(200).send('Se asigno exitosamente el usuario al equipo correspondiente')
    })
})

// RUTA PARA REGISTRAR UN NUEVO REPORTE DE FALLA
router.post('/equipos/reporte/add', (req, res) => {
    const { num_serie, falla } = req.body

    if (!num_serie || !falla) {
        return res.status(400).send('El numero de serie y la falla son requeridos')
    }

    // OBTENER LA FECHA ACTUAL CON FORMATO DD-MM-YYYY
    const fecha = new Date()

    // FORMATEAR LA FECHA EN YYYY-MM-DD
    const anio = fecha.getFullYear()
    const mes = String(fecha.getMonth() + 1).padStart(2, '0')
    const dia = String(fecha.getDate()).padStart(2, '0')

    // CREAR EL STRING EN EL FORMATO DESEADO
    const fecha_reporte = `${anio}-${mes}-${dia}`

    // INICIAR LA TRANSACCION
    db.beginTransaction(err => {
        if (err) {
            return res.status(500).send('Error al iniciar la transaccion')
        }

        // ACTUALIZAMOS EL ESTADO DEL EQUIPO A MANTENIMIENTO
        const updateEstadoQuery = 'UPDATE equipos SET estado="mantenimiento" WHERE num_serie=?'
        db.query(updateEstadoQuery, [num_serie], (err, result) => {
            if (err) {
                return db.rollback(() => {
                    console.error('Error al actualizar el estado', err)
                    return res.status(500).send('Error al actualizar el estado del equipo')
                })
            }

            const id_historial = Date.now()

            //INSERTAR EL NUEVO REGISTRO EN LA TABLA HISTORIAL_MANTENIMIENTOS
            const insertHistorialQuery = `
                INSERT INTO historial_mantenimientos(id_historial, num_serie, fecha_reporte, falla)
                VALUES(?,?,?,?)
                `

            db.query(insertHistorialQuery, [id_historial, num_serie, fecha_reporte, falla], (err, result) => {
                if (err) {
                    return db.rollback(() => {
                        console.error('Error al insertar el historial de mantenimientos', err)
                        return res.status(500).send('Error al insertar el historial de mantenimientos')
                    })
                }

                // CONFIRMAR TRANSACCION
                db.commit(err => {
                    if (err) {
                        return db.rollback(() => {
                            console.error('Error al confirmar la transaccion', err)
                            return res.status(500).send('Error al confirmar la transaccion')
                        })
                    }
                    res.status(200).send('Estado actualizado a mantenimiento y reporte registrado exitosamente ')
                })
            })

        })
    })

})

// RUTA PARA OBTENER LOS MANTENIMIENTOS ORDENADOS POR FECHAS DE REPORTE Y FALTA DE SOLUCION
router.get('/equipos/mantenimientos', (req, res) => {
    const query = 'SELECT * FROM historial_mantenimientos WHERE fecha_solucion IS NULL ORDER BY fecha_reporte DESC'

    db.query(query, (err, results) => {
        if (err) {
            return res.status(500).send('Error en la consulta')
        }
        res.json(results)
    })
})

// RUTA PARA ACTUALIZAR LA SOLUCION EN EL HISTORIAL Y CAMBIAR EL ESTADO DEL EQUIPO
router.post('/equipos/mantenimientos/update', (req, res) => {
    const { num_serie, id_historial, tecnico, solucion } = req.body

    if (!num_serie || !id_historial || !tecnico || !solucion) {
        return res.status(400).send('El id, numero de serie, tecnico y solucion son requeridos')
    }

    // OBTENER LA FECHA CON EL FORMATO DESEADO
    const fecha = new Date()

    const anio = fecha.getFullYear()
    const mes = String(fecha.getMonth() + 1).padStart(2, '0')
    const dia = String(fecha.getDate()).padStart(2, '0')

    const fecha_solucion = `${anio}-${mes}-${dia}`

    // INICIAR TRANSACCION
    db.beginTransaction(err => {
        if (err) {
            return res.status(500).send('Error al iniciar la transaccion')
        }

        // ACTUALIZAMOS EL ESTADO DEL EQUIPO A ACTIVO
        const updateEstadoQuery = 'UPDATE equipos SET estado="activo" WHERE num_serie=?'
        db.query(updateEstadoQuery, [num_serie], (err, result) => {
            if (err) {
                return db.rollback(() => {
                    console.error('Error al actualizar el estado', err)
                    return res.status(500).send('Error al actualizar el estado del equipo')
                })
            }

            // ACTUALIZAMOS EL REGISTRO DE LA TABLA HISTORIAL_MANTENIMIENTOS
            const updateHistorialQuery = `
                UPDATE
                    historial_mantenimientos
                SET
                    fecha_solucion = ?,
                    usuario_tecnico = ?,
                    solucion = ?
                WHERE
                    id_historial = ?
            `
            db.query(updateHistorialQuery, [fecha_solucion, tecnico, solucion, id_historial], (err, result) => {
                if (err) {
                    return db.rollback(() => {
                        console.error('Error al actualizar el historial', err)
                        return res.status(500).send('Error al actualizar el historial')
                    })
                }

                // CONFIRMAR LA TRANSACCION
                db.commit(err => {
                    if (err) {
                        return db.rollback(() => {
                            console.error('Error al confirmar la transaccion', err)
                            return res.status(500).send('Error al confirmar la transaccion')
                        })
                    }
                    res.status(200).send('Estado del equipo actualizado a activo y mantenimiento actualizado')
                })
            })
        })
    })
})

// RUTA PARA OBTENER LOS MANTENIMIENTOS POR ID_HISTORIAL, NUM_SERIE O TECNICO
router.post('/equipos/mantenimientos/find', (req, res) => {
    const { filter } = req.body

    if (!filter) {
        return res.status(400).json({
            error: 'Se debe proporcionar al menos uno de los parametros'
        })
    }

    const query = `SELECT * FROM historial_mantenimientos
                   WHERE id_historial = '${filter}'
                   OR num_serie = '${filter}'
                   OR usuario_tecnico = '${filter}'
                   AND solucion IS NOT NULL`

    db.query(query, (err, results) => {
        if (err) {
            return res.status(500).send('Error en la consulta')
        }
        res.json(results)
    })
})

module.exports = router