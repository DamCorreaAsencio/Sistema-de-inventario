const mysql = require('mysql2')

// CONFIGURACION PARA LA CONEXION A LA BASE DE DATOS
const dbConfig = {
    host: 'localhost',
    user: 'root',
    password: 'admin', //coloca tu respectiva contraseña
    database: 'db_inv_ti'
}

const db = mysql.createConnection(dbConfig)

// CONECTAR A LA BASE DE DATOS
db.connect((err) => {
    if (err) {
        console.error('Error al conectar a la base de datos: ', err)
        return
    }
    console.log('Conectado a la base de datos MySQL')
})

module.exports = db