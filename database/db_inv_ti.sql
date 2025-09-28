create database db_inv_ti;
USE db_inv_ti;
create table areas(
    area varchar(100) primary key
);

create table estados_equipo(
    estado varchar(50) primary key
);

create table usuarios(
    usuario varchar(20) primary key,
    contrasena varchar(10) not null,
    nombre varchar(200) not null,
    area varchar(100) not null,
    correo varchar(50) null,
    estado varchar(15) not null
);

create table equipos(
    num_serie varchar(50) primary key,
    equipo varchar(100) not null,
    area varchar(100) not null,
    descripcion text,
    estado varchar(50) not null,
    responsable varchar(20) null,
    fecha_adquisicion date not null,
    fecha_asignacion date null, /* aquí puede ser not null, depende de si tira o no errores*/
    fecha_baja date null
);

create table historial_mantenimientos(
    id_historial varchar(100) primary key,
    num_serie varchar(50) not null,
    fecha_reporte date not null,
    fecha_solucion date null,
    usuario_tecnico varchar(20) null,
    falla text not null,
    solucion text null
);

create table productos(
    codigo varchar(50) primary key,
    nom_producto varchar(100) not null,
    desc_producto text not null,
    pre_publico double not null,
    pre_proveedor double not null,
    existencias int not null
);

create table ventas(
    id_venta varchar(150) primary key,
    productos text not null,
    total_venta double not null,
    fecha_venta date not null,
    vendedor varchar(20) not null
);

insert into areas (area) values
('tecnologia'),
('administracion'),
('recursos humanos'),
('finanzas'),
('soporte'),
('almacen'),
('ventas');

INSERT INTO productos (codigo, nom_producto, desc_producto, pre_publico, pre_proveedor, existencias) VALUES
('H001', 'Detergente Liquido Ariel 4.65L', 'Detergente liquido para ropa con poder quitamanchas', 120.50, 95.00, 25),
('H002', 'Papel Higiénico Regio 32 Rollos', 'Papel higiénico doble hoja, ultra suave, paquete de 32 rollos', 250.00, 200.00, 50),
('H003', 'Fabuloso Lavanda 1.8L', 'Limpiador multiusos con aroma a lavanda, ideal para pisos y superficies', 45.00, 35.00, 15),
('H004', 'Esponja Scotch-Brite Pack x3', 'Esponjas multiusos resistentes para cocina y baño, paquete de 3 unidades', 25.00, 18.00, 30),
('H005', 'Trapeador Microfibra con Palo', 'Trapeador ultra absorbente con cabezal giratorio', 85.00, 65.00, 10),
('H006', 'Juego de 6 Vasos de Vidrio', 'Vasos resistentes y elegantes para bebidas frías y calientes', 150.00, 110.00, 20),
('H007', 'Sarten Antiadherente 24cm', 'Sartén de aluminio con recubrimiento antiadherente, 24cm de diámetro', 180.00, 140.00, 12),
('H008', 'Ambientador Glade Manzana Canela', 'Aerosol aromatizante para el hogar, 275g', 55.00, 40.00, 40),
('H009', 'Cubo de Basura con Tapa 25L', 'Contenedor de plástico resistente con pedal y tapa, 25 litros', 210.00, 160.00, 8),
('H010', 'Toallas de Cocina Absorbentes x3', 'Toallas de tela absorbente reutilizables, paquete de 3 unidades', 70.00, 55.00, 22);

INSERT into estados_equipo (estado) values
('activo'),
('mantenimiento'),
('baja'),
('inactivo'),
('reservado');

INSERT INTO equipos (num_serie, equipo, area, descripcion, estado, responsable, fecha_adquisicion, fecha_asignacion, fecha_baja) VALUES
('E001', 'Laptop Dell XPS 13"', 'tecnologia', 'Laptop de alto rendimiento para desarrollo de software', 'activo', 'juan.perez', '2023-01-15', '2023-02-01', NULL),
('E002', 'Monitor Samsung 27"', 'tecnologia', 'Monitor 4K de 27 pulgadas', 'activo', 'maria.lopez', '2023-01-15', '2023-02-01', NULL),
('E003', 'Impresora HP LaserJet', 'administracion', 'Impresora láser color', 'activo', NULL, '2022-05-20', '2022-06-01', NULL),
('E004', 'Servidor Dell R740', 'tecnologia', 'Servidor para almacenamiento de datos', 'activo', NULL, '2021-11-10', '2021-11-15', NULL),
('E005', 'Escáner Canon LIDE 300', 'administracion', 'Escáner de documentos A4', 'mantenimiento', 'pedro.gonzalez', '2023-03-01', '2023-03-10', NULL),
('E006', 'Laptop Lenovo ThinkPad', 'almacen', 'Laptop para soporte a usuarios', 'mantenimiento', 'laura.rodriguez', '2022-08-05', '2022-08-15', NULL),
('E007', 'Proyector Epson EB-X41', 'almacen', 'Proyector multimedia para presentaciones', 'reservado', NULL, '2023-04-10', NULL, NULL),
('E008', 'Teclado Mecánico Logitech', 'tecnologia', 'Teclado mecánico para desarrollo de software', 'activo', 'carlos.ahumada', '2023-02-20', '2023-03-05', NULL),
('E009', 'Router Cisco 2900', 'tecnologia', 'Router para red corporativa', 'mantenimiento', NULL, '2021-09-01', '2021-09-05', NULL),
('E010', 'Tablet Samsung Galaxy Tab', 'administracion', 'Tablet para gestión de tareas', 'activo', 'ana.gomez', '2023-05-01', '2023-05-15', NULL);

INSERT INTO db_inv_ti.usuarios (usuario, contrasena, nombre, area, correo, estado) VALUES 
('ramonp', '1234', 'Ramón Pérez', 'tecnologia', 'ramon.perez@empresa.com', 'activo'),
('mlopez',     '1234',     'María López',        'tecnologia',        'maria.lopez@empresa.com',       'activo'),
('jcastillo',  'abcd1234', 'Jorge Castillo',     'tecnologia',        'jorge.castillo@empresa.com',    'activo');

-- ADMINISTRACION
INSERT INTO db_inv_ti.usuarios VALUES
('acastro',    '1234',     'Ana Castro',         'administracion',    'ana.castro@empresa.com',        'activo'),
('mgutierrez', 'abcd1234', 'Marco Gutiérrez',    'administracion',    'marco.gutierrez@empresa.com',   'activo');

-- RECURSOS HUMANOS
INSERT INTO db_inv_ti.usuarios VALUES
('rsolis',     '1234',     'Rosa Solís',         'recursos humanos',  'rosa.solis@empresa.com',        'activo'),
('lvera',      'abcd1234', 'Luis Vera',          'recursos humanos',  'luis.vera@empresa.com',         'activo');

-- FINANZAS
INSERT INTO db_inv_ti.usuarios VALUES
('fquiroz',    '1234',     'Fiorella Quiróz',    'finanzas',          'fiorella.quiroz@empresa.com',   'activo'),
('pmendoza',   'abcd1234', 'Pedro Mendoza',      'finanzas',          'pedro.mendoza@empresa.com',     'activo');

-- SOPORTE
INSERT INTO db_inv_ti.usuarios VALUES
('srojas',     '1234',     'Sergio Rojas',       'soporte',           'sergio.rojas@empresa.com',      'activo'),
('kvaldez',    'abcd1234', 'Karla Valdez',       'soporte',           'karla.valdez@empresa.com',      'activo');

-- ALMACEN
INSERT INTO db_inv_ti.usuarios VALUES
('jhuaman',    '1234',     'José Huamán',        'almacen',           'jose.huaman@empresa.com',       'activo'),
('dchavez',    'abcd1234', 'Diego Chávez',       'almacen',           'diego.chavez@empresa.com',      'activo');

-- VENTAS
INSERT INTO db_inv_ti.usuarios VALUES
('vgarcia',    '1234',     'Valeria García',     'ventas',            'valeria.garcia@empresa.com',    'activo'),
('psalazar',   'abcd1234', 'Pablo Salazar',      'ventas',            'pablo.salazar@empresa.com',     'activo');

SELECT area, COUNT(*) AS usuarios_por_area
FROM db_inv_ti.usuarios
GROUP BY area;
