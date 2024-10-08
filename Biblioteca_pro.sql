
IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'biblioteca_instituto')
BEGIN
    CREATE DATABASE biblioteca_instituto;
END
GO

USE biblioteca_instituto;
GO


CREATE TABLE usuarios (
    id_usuario INT IDENTITY(1,1) PRIMARY KEY,
    nombre NVARCHAR(100) NOT NULL,
    apellido NVARCHAR(100) NOT NULL,
    email NVARCHAR(100) UNIQUE NOT NULL,
    telefono NVARCHAR(15),
    direccion NVARCHAR(150),
    tipo_usuario NVARCHAR(20) NOT NULL CHECK (tipo_usuario IN ('estudiante', 'profesor', 'personal', 'administrador')),
    fecha_registro DATE NOT NULL,
    estado NVARCHAR(20) NOT NULL CHECK (estado IN ('activo', 'inactivo'))
);
GO


CREATE TABLE autores (
    id_autor INT IDENTITY(1,1) PRIMARY KEY,
    nombre NVARCHAR(100) NOT NULL,
    apellido NVARCHAR(100) NOT NULL,
    nacionalidad NVARCHAR(50)
);
GO


CREATE TABLE categorias (
    id_categoria INT IDENTITY(1,1) PRIMARY KEY,
    nombre NVARCHAR(50) UNIQUE NOT NULL
);
GO


CREATE TABLE libros (
    id_libro INT IDENTITY(1,1) PRIMARY KEY,
    titulo NVARCHAR(200) NOT NULL,
    isbn NVARCHAR(20) UNIQUE NOT NULL,
    editorial NVARCHAR(100),
    año_publicacion DATE NOT NULL,
    id_categoria INT NOT NULL,
    cantidad_disponible INT DEFAULT 1 NOT NULL,
    tipo_libro NVARCHAR(20) NOT NULL CHECK (tipo_libro IN ('físico', 'digital')),
    url_digital NVARCHAR(255),
    FOREIGN KEY (id_categoria) REFERENCES categorias(id_categoria)
);
GO


CREATE TABLE libros_autores (
    id_libro INT NOT NULL,
    id_autor INT NOT NULL,
    PRIMARY KEY (id_libro, id_autor),
    FOREIGN KEY (id_libro) REFERENCES libros(id_libro),
    FOREIGN KEY (id_autor) REFERENCES autores(id_autor)
);
GO


CREATE TABLE prestamos (
    id_prestamo INT IDENTITY(1,1) PRIMARY KEY,
    id_usuario INT NOT NULL,
    fecha_prestamo DATE NOT NULL,
    fecha_devolucion DATE,
    estado_prestamo NVARCHAR(20) NOT NULL CHECK (estado_prestamo IN ('prestado', 'devuelto', 'retrasado')),
    FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario)
);
GO


CREATE TABLE prestamos_libros (
    id_prestamo INT,
    id_libro INT,
    PRIMARY KEY (id_prestamo, id_libro),
    FOREIGN KEY (id_prestamo) REFERENCES prestamos(id_prestamo),
    FOREIGN KEY (id_libro) REFERENCES libros(id_libro)
);
GO


CREATE TABLE devoluciones (
    id_devolucion INT IDENTITY(1,1) PRIMARY KEY,
    id_prestamo INT NOT NULL,
    fecha_devolucion DATE NULL,
    observaciones NVARCHAR(MAX),
    FOREIGN KEY (id_prestamo) REFERENCES prestamos(id_prestamo)
);
GO


CREATE TABLE reservas (
    id_reserva INT IDENTITY(1,1) PRIMARY KEY,
    id_libro INT NOT NULL,
    id_usuario INT NOT NULL,
    fecha_reserva DATE NOT NULL,
    estado_reserva NVARCHAR(20) NOT NULL CHECK (estado_reserva IN ('reservado', 'cancelado')),
    FOREIGN KEY (id_libro) REFERENCES libros(id_libro),
    FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario)
);
GO


CREATE TABLE historial_prestamos (
    id_historial_prestamo INT IDENTITY(1,1) PRIMARY KEY,
    id_prestamo INT NOT NULL,
    fecha_cambio DATE NOT NULL,
    estado_anterior NVARCHAR(20) NOT NULL CHECK (estado_anterior IN ('prestado', 'devuelto', 'retrasado')),
    estado_nuevo NVARCHAR(20) NOT NULL CHECK (estado_nuevo IN ('prestado', 'devuelto', 'retrasado')),
    observaciones NVARCHAR(MAX),
    FOREIGN KEY (id_prestamo) REFERENCES prestamos(id_prestamo)
);
GO


CREATE TABLE sanciones (
    id_sancion INT IDENTITY(1,1) PRIMARY KEY,
    id_usuario INT NOT NULL,
    id_prestamo INT NOT NULL,
    monto_sancion DECIMAL(10,2) NOT NULL,
    fecha_sancion DATE NOT NULL,
    estado_sancion NVARCHAR(20) NOT NULL CHECK (estado_sancion IN ('pagada', 'pendiente')),
    FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario),
    FOREIGN KEY (id_prestamo) REFERENCES prestamos(id_prestamo)
);
GO

INSERT INTO usuarios (nombre, apellido, email, telefono, direccion, tipo_usuario, fecha_registro, estado)
VALUES
('Ana', 'García', 'ana.garcia@example.com', '1234567890', 'Calle 1, Ciudad', 'estudiante', GETDATE(), 'activo'),
('Luis', 'Martínez', 'luis.martinez@example.com', '1234567891', 'Calle 2, Ciudad', 'profesor', GETDATE(), 'activo'),
('María', 'López', 'maria.lopez@example.com', '1234567892', 'Calle 3, Ciudad', 'personal', GETDATE(), 'inactivo'),
('Juan', 'Pérez', 'juan.perez@example.com', '1234567893', 'Calle 4, Ciudad', 'administrador', GETDATE(), 'activo'),
('Carlos', 'Sánchez', 'carlos.sanchez@example.com', '1234567894', 'Calle 5, Ciudad', 'estudiante', GETDATE(), 'activo'),
('Laura', 'Ramírez', 'laura.ramirez@example.com', '1234567895', 'Calle 6, Ciudad', 'profesor', GETDATE(), 'activo'),
('David', 'Fernández', 'david.fernandez@example.com', '1234567896', 'Calle 7, Ciudad', 'personal', GETDATE(), 'activo'),
('Sofía', 'Gómez', 'sofia.gomez@example.com', '1234567897', 'Calle 8, Ciudad', 'administrador', GETDATE(), 'inactivo'),
('Javier', 'Morales', 'javier.morales@example.com', '1234567898', 'Calle 9, Ciudad', 'estudiante', GETDATE(), 'activo'),
('Marta', 'Vázquez', 'marta.vazquez@example.com', '1234567899', 'Calle 10, Ciudad', 'profesor', GETDATE(), 'activo'),
('Pedro', 'García', 'pedro.garcia@example.com', '1234567800', 'Calle 11, Ciudad', 'personal', GETDATE(), 'activo'),
('Claudia', 'Hernández', 'claudia.hernandez@example.com', '1234567801', 'Calle 12, Ciudad', 'administrador', GETDATE(), 'activo'),
('José', 'Jiménez', 'jose.jimenez@example.com', '1234567802', 'Calle 13, Ciudad', 'estudiante', GETDATE(), 'inactivo'),
('Isabel', 'Moreno', 'isabel.moreno@example.com', '1234567803', 'Calle 14, Ciudad', 'profesor', GETDATE(), 'activo'),
('Antonio', 'Gutiérrez', 'antonio.gutierrez@example.com', '1234567804', 'Calle 15, Ciudad', 'personal', GETDATE(), 'activo'),
('Beatriz', 'Álvarez', 'beatriz.alvarez@example.com', '1234567805', 'Calle 16, Ciudad', 'administrador', GETDATE(), 'inactivo'),
('Ricardo', 'Castro', 'ricardo.castro@example.com', '1234567806', 'Calle 17, Ciudad', 'estudiante', GETDATE(), 'activo'),
('Paola', 'Ramírez', 'paola.ramirez@example.com', '1234567807', 'Calle 18, Ciudad', 'profesor', GETDATE(), 'activo'),
('Alberto', 'Pardo', 'alberto.pardo@example.com', '1234567808', 'Calle 19, Ciudad', 'personal', GETDATE(), 'activo'),
('Valeria', 'Suárez', 'valeria.suarez@example.com', '1234567809', 'Calle 20, Ciudad', 'administrador', GETDATE(), 'activo');


INSERT INTO autores (nombre, apellido, nacionalidad)
VALUES
('James', 'Smith', 'Estadounidense'),
('Maria', 'González', 'Española'),
('John', 'Doe', 'Británico'),
('Elena', 'Martínez', 'Argentina'),
('Robert', 'Johnson', 'Canadiense'),
('Patricia', 'Brown', 'Mexicana'),
('Michael', 'Williams', 'Alemán'),
('Jennifer', 'Wilson', 'Chilena'),
('David', 'Lee', 'Australiano'),
('Linda', 'Taylor', 'Colombiana'),
('William', 'Davis', 'Francés'),
('Jessica', 'Clark', 'Peruana'),
('Richard', 'Miller', 'Italiano'),
('Mary', 'Rodriguez', 'Brasileña'),
('Charles', 'Garcia', 'Sueca'),
('Nancy', 'Harris', 'Nicaragüense'),
('Steven', 'White', 'Uruguayo'),
('Elizabeth', 'Martin', 'Cubano'),
('Paul', 'Thompson', 'Panameño'),
('Helen', 'Lopez', 'Ecuatoriana');


INSERT INTO categorias (nombre)
VALUES
('Programación'),
('Redes'),
('Seguridad Informática'),
('Base de Datos'),
('Desarrollo Web'),
('Inteligencia Artificial'),
('Machine Learning'),
('Computación en la Nube'),
('Sistemas Operativos'),
('Hardware'),
('Desarrollo de Software'),
('Robótica'),
('Ciencia de Datos'),
('Blockchain'),
('Big Data'),
('IoT'),
('Realidad Aumentada'),
('Realidad Virtual'),
('Computación Cuántica'),
('Tecnologías Emergentes');


INSERT INTO libros (titulo, isbn, editorial, año_publicacion, id_categoria, cantidad_disponible, tipo_libro, url_digital)
VALUES
('Introducción a la Programación', '978-3-16-1484-0', 'Editorial Tech', '2023-01-15', 1, 10, 'físico', NULL),
('Redes y Comunicaciones', '978-1-23-456789-0', 'Editorial Net', '2022-05-22', 2, 8, 'físico', NULL),
('Fundamentos de Seguridad Informática', '978-1-23-456789', 'Editorial Sec', '2023-03-10', 3, 12, 'digital', 'http://example.com/libro1'),
('Bases de Datos Avanzadas', '978-1-23-456789-2', 'Editorial DB', '2021-09-18', 4, 5, 'físico', NULL),
('Desarrollo Web Moderno', '978-1-23-456789-3', 'Editorial Web', '2022-11-11', 5, 7, 'digital', 'http://example.com/libro2'),
('Inteligencia Artificial: Una Introducción', '978-1-23-456789-4', 'Editorial AI', '2023-07-30', 6, 15, 'digital', 'http://example.com/libro3'),
('Machine Learning en Acción', '978-1-23-456789-5', 'Editorial ML', '2023-02-20', 7, 9, 'físico', NULL),
('Computación en la Nube: Guía Completa', '978-1-23-456789-6', 'Editorial Cloud', '2022-06-15', 8, 14, 'digital', 'http://example.com/libro4'),
('Sistemas Operativos Modernos', '978-1-23-456789-7', 'Editorial OS', '2021-12-01', 9, 6, 'físico', NULL),
('Hardware para Desarrolladores', '978-1-23-456789-8', 'Editorial Hardware', '2023-04-25', 10, 10, 'digital', 'http://example.com/libro5'),
('Robótica: Fundamentos y Aplicaciones', '978-1-23-456789-9', 'Editorial Robotics', '2022-08-30', 11, 8, 'físico', NULL),
('Ciencia de Datos para Todos', '978-1-23-456780-0', 'Editorial Data', '2023-05-12', 12, 11, 'digital', 'http://example.com/libro6'),
('Blockchain y Criptomonedas', '978-1-23-456780-1', 'Editorial Crypto', '2022-09-10', 13, 9, 'físico', NULL),
('Big Data: Estrategias y Herramientas', '978-1-23-456780-2', 'Editorial BigData', '2023-03-22', 14, 13, 'digital', 'http://example.com/libro7'),
('IoT: Internet de las Cosas', '978-1-23-456780-3', 'Editorial IoT', '2022-10-10', 15, 7, 'físico', NULL),
('Realidad Aumentada y Virtual', '978-1-23-456780-4', 'Editorial ARVR', '2023-06-05', 16, 12, 'digital', 'http://example.com/libro8'),
('Computación Cuántica para Principiantes', '978-1-23-456780-5', 'Editorial Quantum', '2023-08-18', 17, 6, 'físico', NULL),
('Tecnologías Emergentes en TI', '978-1-23-456780-6', 'Editorial Emerging', '2022-11-20', 18, 8, 'digital', 'http://example.com/libro9'),
('Programación Avanzada en Python', '978-1-23-456780-7', 'Editorial Python', '2023-01-30', 1, 11, 'físico', NULL),
('Redes de Alta Velocidad', '978-1-23-456780-8', 'Editorial Speed', '2023-02-15', 2, 13, 'digital', 'http://example.com/libro10'),
('Seguridad en la Nube', '978-1-23-456780-9', 'Editorial CloudSec', '2023-04-10', 3, 10, 'físico', NULL);


INSERT INTO libros_autores (id_libro, id_autor)
VALUES
(4, 1),
(4, 2),
(5, 3),
(6, 4),
(7, 5),
(4, 6),
(4, 7),
(4, 8),
(5, 9),
(5, 10),
(6, 11),
(6, 12),
(7, 13),
(7, 14),
(8, 15),
(8, 16),
(9, 17),
(9, 18),
(10, 1),
(10, 2);



INSERT INTO prestamos (id_libro, id_usuario, fecha_prestamo, fecha_devolucion, estado_prestamo)
VALUES
(4, 1, '2024-01-15', NULL, 'prestado'),
(5, 2, '2024-02-01', NULL, 'prestado'),
(6, 3, '2024-03-10', '2024-04-10', 'devuelto'),
(4, 4, '2024-04-15', NULL, 'prestado'),
(5, 5, '2024-05-01', '2024-06-01', 'devuelto'),
(6, 6, '2024-06-10', NULL, 'prestado'),
(7, 7, '2024-07-20', '2024-08-20', 'devuelto'),
(8, 8, '2024-08-01', NULL, 'prestado'),
(9, 9, '2024-09-10', '2024-10-10', 'devuelto'),
(10, 10, '2024-10-15', NULL, 'prestado'),
(11, 11, '2024-11-01', '2024-12-01', 'devuelto'),
(12, 12, '2024-12-10', NULL, 'prestado'),
(13, 13, '2024-01-05', '2024-02-05', 'devuelto'),
(14, 14, '2024-02-20', NULL, 'prestado'),
(15, 15, '2024-03-15', '2024-04-15', 'devuelto'),
(16, 16, '2024-04-01', NULL, 'prestado'),
(17, 17, '2024-05-10', '2024-06-10', 'devuelto'),
(18, 18, '2024-06-15', NULL, 'prestado'),
(19, 19, '2024-07-05', '2024-08-05', 'devuelto'),
(20, 20, '2024-08-10', NULL, 'prestado');


INSERT INTO devoluciones (id_prestamo, fecha_devolucion, observaciones)
VALUES
(4, '2024-01-30', 'Devolución a tiempo'),
(5, '2024-02-20', 'Devolución con retraso'),
(6, '2024-04-10', 'Devolución a tiempo'),
(7, '2024-05-01', 'Devolución a tiempo'),
(8, '2024-06-01', 'Devolución a tiempo'),
(9, NULL, 'Pendiente de devolución'),
(10, '2024-08-20', 'Devolución a tiempo'),
(11, NULL, 'Pendiente de devolución'),
(12, '2024-10-10', 'Devolución a tiempo'),
(13, NULL, 'Pendiente de devolución'),
(14, '2024-12-01', 'Devolución a tiempo'),
(15, NULL, 'Pendiente de devolución'),
(16, '2024-02-05', 'Devolución a tiempo'),
(17, NULL, 'Pendiente de devolución'),
(18, '2024-04-15', 'Devolución a tiempo'),
(19, NULL, 'Pendiente de devolución'),
(20, '2024-06-10', 'Devolución a tiempo');


INSERT INTO reservas (id_libro, id_usuario, fecha_reserva, estado_reserva)
VALUES
(7, 4, '2024-04-01', 'reservado'),
(5, 5, '2024-05-01', 'reservado'),
(6, 6, '2024-06-01', 'reservado'),
(7, 7, '2024-07-01', 'reservado'),
(8, 8, '2024-08-01', 'reservado'),
(9, 9, '2024-09-01', 'reservado'),
(10, 10, '2024-10-01', 'reservado'),
(11, 11, '2024-11-01', 'reservado'),
(12, 12, '2024-12-01', 'reservado'),
(13, 13, '2024-01-02', 'reservado'),
(14, 14, '2024-02-02', 'reservado'),
(15, 15, '2024-03-02', 'reservado'),
(16, 16, '2024-04-02', 'reservado'),
(17, 17, '2024-05-02', 'reservado'),
(18, 18, '2024-06-02', 'reservado'),
(19, 19, '2024-07-02', 'reservado'),
(20, 20, '2024-08-02', 'reservado');


INSERT INTO historial_prestamos (id_prestamo, fecha_cambio, estado_anterior, estado_nuevo, observaciones)
VALUES
(4, '2024-05-01', 'prestado', 'devuelto', 'Cambio de estado a devuelto'),
(5, '2024-06-01', 'prestado', 'devuelto', 'Cambio de estado a devuelto'),
(6, '2024-07-01', 'prestado', 'devuelto', 'Cambio de estado a devuelto'),
(7, '2024-08-20', 'prestado', 'devuelto', 'Cambio de estado a devuelto'),
(8, '2024-09-01', 'prestado', 'devuelto', 'Cambio de estado a devuelto'),
(9, '2024-10-10', 'prestado', 'devuelto', 'Cambio de estado a devuelto'),
(10, '2024-11-01', 'prestado', 'devuelto', 'Cambio de estado a devuelto'),
(11, '2024-12-01', 'prestado', 'devuelto', 'Cambio de estado a devuelto'),
(12, '2024-01-15', 'prestado', 'devuelto', 'Cambio de estado a devuelto'),
(13, '2024-02-05', 'prestado', 'devuelto', 'Cambio de estado a devuelto'),
(14, '2024-03-15', 'prestado', 'devuelto', 'Cambio de estado a devuelto'),
(15, '2024-04-01', 'prestado', 'devuelto', 'Cambio de estado a devuelto'),
(16, '2024-05-10', 'prestado', 'devuelto', 'Cambio de estado a devuelto'),
(17, '2024-06-15', 'prestado', 'devuelto', 'Cambio de estado a devuelto'),
(18, '2024-07-05', 'prestado', 'devuelto', 'Cambio de estado a devuelto'),
(19, '2024-08-10', 'prestado', 'devuelto', 'Cambio de estado a devuelto'),
(20, '2024-09-15', 'prestado', 'devuelto', 'Cambio de estado a devuelto');

-- Inserción en la tabla 'prestamos_libros'
INSERT INTO prestamos_libros (id_prestamo, id_libro) 
VALUES
(1, 1),
(1, 2);

INSERT INTO prestamos_libros (id_prestamo, id_libro) 
VALUES
(2, 3),
(2, 4),
(2, 5);

INSERT INTO prestamos_libros (id_prestamo, id_libro) 
VALUES
(3, 6),
(3, 7);

INSERT INTO prestamos_libros (id_prestamo, id_libro) 
VALUES
(4, 8),
(4, 9),
(4, 10),
(4, 11);

INSERT INTO prestamos_libros (id_prestamo, id_libro) 
VALUES
(5, 12),
(5, 13),
(5, 14);

INSERT INTO prestamos_libros (id_prestamo, id_libro) 
VALUES
(6, 15),
(6, 16);

INSERT INTO prestamos_libros (id_prestamo, id_libro) 
VALUES
(7, 17),
(7, 18),
(7, 19),
(7, 20);

INSERT INTO prestamos_libros (id_prestamo, id_libro) 
VALUES
(8, 1),
(8, 5),
(8, 9);

INSERT INTO prestamos_libros (id_prestamo, id_libro) 
VALUES
(9, 10),
(9, 14);

INSERT INTO prestamos_libros (id_prestamo, id_libro) 
VALUES
(10, 11),
(10, 12),
(10, 13),
(10, 15);


CREATE VIEW libros_disponibles AS
SELECT l.id_libro, l.titulo, l.isbn, l.editorial, l.año_publicacion, l.cantidad_disponible
FROM libros l
WHERE l.cantidad_disponible > 0;

SELECT * FROM libros_disponibles;


CREATE VIEW historial_prestamos_usuario AS
SELECT u.nombre, u.apellido, l.titulo, p.fecha_prestamo, p.fecha_devolucion, p.estado_prestamo
FROM prestamos p
JOIN usuarios u ON p.id_usuario = u.id_usuario
JOIN prestamos_libros pl ON p.id_prestamo = pl.id_prestamo
JOIN libros l ON pl.id_libro = l.id_libro;

SELECT * FROM historial_prestamos_usuario;


CREATE VIEW reservas_disponibles AS
SELECT r.id_reserva, u.nombre, u.apellido, l.titulo, r.fecha_reserva
FROM reservas r
JOIN usuarios u ON r.id_usuario = u.id_usuario
JOIN libros l ON r.id_libro = l.id_libro
WHERE r.estado_reserva = 'reservado';

SELECT * FROM reservas_disponibles;


CREATE VIEW devoluciones_pendientes AS
SELECT p.id_prestamo, u.nombre, u.apellido, l.titulo, d.fecha_devolucion
FROM devoluciones d
JOIN prestamos p ON d.id_prestamo = p.id_prestamo
JOIN usuarios u ON p.id_usuario = u.id_usuario
JOIN prestamos_libros pl ON p.id_prestamo = pl.id_prestamo
JOIN libros l ON pl.id_libro = l.id_libro
WHERE d.fecha_devolucion IS NULL;

SELECT * FROM devoluciones_pendientes;


CREATE VIEW libros_por_autor AS
SELECT a.nombre AS autor_nombre, a.apellido AS autor_apellido, l.titulo, l.isbn
FROM libros_autores la
JOIN autores a ON la.id_autor = a.id_autor
JOIN libros l ON la.id_libro = l.id_libro;

SELECT * FROM libros_por_autor;

-- Procedimientos Almacenados --
CREATE PROCEDURE crear_usuario
    @p_nombre NVARCHAR(50),
    @p_apellido NVARCHAR(50),
    @p_email NVARCHAR(100),
    @p_telefono NVARCHAR(15),
    @p_direccion NVARCHAR(100),
    @p_tipo_usuario NVARCHAR(20),
    @p_fecha_registro DATE,
    @p_estado NVARCHAR(20)
AS
BEGIN
    INSERT INTO usuarios (nombre, apellido, email, telefono, direccion, tipo_usuario, fecha_registro, estado)
    VALUES (@p_nombre, @p_apellido, @p_email, @p_telefono, @p_direccion, @p_tipo_usuario, @p_fecha_registro, @p_estado);
END;
GO


CREATE PROCEDURE eliminar_libro
    @p_id_libro INT
AS
BEGIN
    DELETE FROM libros
    WHERE id_libro = @p_id_libro;
END;
GO


CREATE PROCEDURE reservar_libro
    @p_id_libro INT,
    @p_id_usuario INT,
    @p_fecha_reserva DATE,
    @p_estado_reserva NVARCHAR(20)
AS
BEGIN
    INSERT INTO reservas (id_libro, id_usuario, fecha_reserva, estado_reserva)
    VALUES (@p_id_libro, @p_id_usuario, @p_fecha_reserva, @p_estado_reserva);
END;
GO


CREATE PROCEDURE actualizar_estado_prestamo
    @p_id_prestamo INT,
    @p_estado_prestamo NVARCHAR(20)
AS
BEGIN
    UPDATE prestamos
    SET estado_prestamo = @p_estado_prestamo
    WHERE id_prestamo = @p_id_prestamo;
END;
GO


CREATE PROCEDURE actualizar_estado_libro
    @p_id_libro INT,
    @p_cantidad_disponible INT
AS
BEGIN
    UPDATE libros
    SET cantidad_disponible = @p_cantidad_disponible
    WHERE id_libro = @p_id_libro;
END;
GO


CREATE PROCEDURE consultar_prestamos_usuario
    @p_id_usuario INT
AS
BEGIN
    SELECT p.id_prestamo, l.titulo, p.fecha_prestamo, p.fecha_devolucion, p.estado_prestamo
    FROM prestamos p
    JOIN prestamos_libros pl ON p.id_prestamo = pl.id_prestamo
    JOIN libros l ON pl.id_libro = l.id_libro
    WHERE p.id_usuario = @p_id_usuario;
END;
GO


CREATE PROCEDURE eliminar_reserva
    @p_id_reserva INT
AS
BEGIN
    DELETE FROM reservas
    WHERE id_reserva = @p_id_reserva;
END;
GO

CREATE PROCEDURE consultar_devoluciones_pendientes
AS
BEGIN
    SELECT p.id_prestamo, u.nombre, u.apellido, l.titulo
    FROM devoluciones d
    JOIN prestamos p ON d.id_prestamo = p.id_prestamo
    JOIN usuarios u ON p.id_usuario = u.id_usuario
    JOIN prestamos_libros pl ON p.id_prestamo = pl.id_prestamo
    JOIN libros l ON pl.id_libro = l.id_libro
    WHERE d.fecha_devolucion IS NULL;
END;
GO


CREATE PROCEDURE consultar_libros_por_autor
    @p_id_autor INT
AS
BEGIN
    SELECT l.titulo, l.isbn
    FROM libros_autores la
    JOIN libros l ON la.id_libro = l.id_libro
    WHERE la.id_autor = @p_id_autor;
END;
GO


CREATE PROCEDURE actualizar_libro
    @p_id_libro INT,
    @p_titulo VARCHAR(100),
    @p_isbn VARCHAR(20),
    @p_editorial VARCHAR(100),
    @p_año_publicacion DATE,
    @p_id_categoria INT,
    @p_cantidad_disponible INT,
    @p_tipo_libro VARCHAR(10),
    @p_url_digital VARCHAR(255)
AS
BEGIN
    UPDATE libros
    SET titulo = @p_titulo,
        isbn = @p_isbn,
        editorial = @p_editorial,
        año_publicacion = @p_año_publicacion,
        id_categoria = @p_id_categoria,
        cantidad_disponible = @p_cantidad_disponible,
        tipo_libro = @p_tipo_libro,
        url_digital = @p_url_digital
    WHERE id_libro = @p_id_libro;
END;
GO

-- Procedimientos almacenados para implementar las reglas del negocio --

CREATE PROCEDURE verificar_disponibilidad_libro
    @p_id_libro INT,
    @p_disponible INT OUTPUT
AS
BEGIN
    SELECT @p_disponible = cantidad_disponible
    FROM libros
    WHERE id_libro = @p_id_libro;
END;
GO


CREATE PROCEDURE aplicar_multa_retraso
    @p_id_prestamo INT,
    @p_monto_multa DECIMAL(10,2)
AS
BEGIN
    UPDATE prestamos
    SET multa = @p_monto_multa
    WHERE id_prestamo = @p_id_prestamo
      AND estado_prestamo = 'retrasado';
END;
GO


CREATE PROCEDURE informe_libro_pendiente
AS
BEGIN
    SELECT
        l.titulo AS libro_titulo,
        a.nombre AS autor_nombre,
        a.apellido AS autor_apellido,
        u.nombre AS usuario_nombre,
        p.fecha_prestamo AS fecha_prestamo
    FROM prestamos p
    JOIN libros l ON p.id_libro = l.id_libro
    JOIN usuarios u ON p.id_usuario = u.id_usuario
    JOIN libros_autores la ON l.id_libro = la.id_libro
    JOIN autores a ON la.id_autor = a.id_autor
    WHERE p.estado_prestamo = 'prestado';
END;
GO






















