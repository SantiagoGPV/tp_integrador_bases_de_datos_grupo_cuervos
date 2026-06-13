CREATE DATABASE tpIntegradorCuervos;
USE tpIntegradorCuervos;

CREATE TABLE GENERO (
    id_genero INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL UNIQUE,
    descripcion TEXT
);


CREATE TABLE AUTOR (
    id_autor INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    nacionalidad VARCHAR(100) NOT NULL
);


CREATE TABLE LIBRO (
    isbn VARCHAR(20) PRIMARY KEY,
    titulo VARCHAR(255) NOT NULL,
    anio_publicacion INT,
    stock_total INT NOT NULL,
    stock_disponible INT NOT NULL,
    CONSTRAINT chk_stock CHECK (stock_disponible <= stock_total),
    CONSTRAINT chk_stock_positivo CHECK (stock_disponible >= 0)
);


CREATE TABLE SOCIO (
    id_socio INT AUTO_INCREMENT PRIMARY KEY,
    dni VARCHAR(15) NOT NULL UNIQUE,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    fecha_alta DATE NOT NULL,
    estado VARCHAR(20) NOT NULL DEFAULT 'ACTIVO',
    CONSTRAINT chk_estado_socio CHECK (estado IN ('ACTIVO', 'SUSPENDIDO', 'BAJA'))
);


CREATE TABLE LIBRO_AUTOR (
    isbn VARCHAR(20),
    id_autor INT,
    PRIMARY KEY (isbn, id_autor),
    FOREIGN KEY (isbn) REFERENCES LIBRO(isbn) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_autor) REFERENCES AUTOR(id_autor) ON DELETE CASCADE ON UPDATE CASCADE
);


CREATE TABLE LIBRO_GENERO (
    isbn VARCHAR(20),
    id_genero INT,
    PRIMARY KEY (isbn, id_genero),
    FOREIGN KEY (isbn) REFERENCES LIBRO(isbn) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_genero) REFERENCES GENERO(id_genero) ON DELETE CASCADE ON UPDATE CASCADE
);


CREATE TABLE EJEMPLAR (
    id_ejemplar INT AUTO_INCREMENT PRIMARY KEY,
    isbn VARCHAR(20) NOT NULL,
    nro_ejemplar INT NOT NULL,
    estado_fisico VARCHAR(20) NOT NULL DEFAULT 'DISPONIBLE',
    CONSTRAINT chk_estado_ejemplar CHECK (estado_fisico IN ('DISPONIBLE', 'PRESTADO', 'BAJA')),
    FOREIGN KEY (isbn) REFERENCES LIBRO(isbn) ON DELETE RESTRICT ON UPDATE CASCADE -- Si se borra libro pero tiene ejemplares "restrict"
);


CREATE TABLE SANCION (
    id_sancion INT AUTO_INCREMENT PRIMARY KEY,
    id_socio INT NOT NULL,
    tipo VARCHAR(50) NOT NULL,
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE NOT NULL,
    motivo TEXT NOT NULL,
    FOREIGN KEY (id_socio) REFERENCES SOCIO(id_socio) ON DELETE CASCADE ON UPDATE CASCADE
);


CREATE TABLE PRESTAMO (
    id_prestamo INT AUTO_INCREMENT PRIMARY KEY,
    id_socio INT NOT NULL,
    id_ejemplar INT NOT NULL,
    fecha_prestamo DATE NOT NULL,
    fecha_vencimiento DATE NOT NULL,
    fecha_devolucion DATE,
    estado VARCHAR(20) NOT NULL DEFAULT 'ACTIVO',
    FOREIGN KEY (id_socio) REFERENCES SOCIO(id_socio) ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (id_ejemplar) REFERENCES EJEMPLAR(id_ejemplar) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT chk_estado_prestamo CHECK (estado IN ('ACTIVO', 'DEVUELTO', 'VENCIDO'))
);


CREATE TABLE AUDITORIA_PRESTAMOS (
    id_auditoria INT AUTO_INCREMENT PRIMARY KEY,
    id_prestamo INT NOT NULL,
    accion VARCHAR(10) NOT NULL, -- 'INSERT', 'UPDATE' o 'DELETE'
    estado_anterior VARCHAR(20),
    estado_nuevo VARCHAR(20),
    fecha_cambio DATETIME NOT NULL,
    usuario_bd VARCHAR(100) NOT NULL
);

CREATE INDEX idx_busqueda_dni ON SOCIO(dni);
CREATE INDEX idx_busqueda_email ON SOCIO(email);
-- El ISBN ya es PK en LIBRO, lo indexamos en EJEMPLAR donde es FK. Acelera Joins con Libro
CREATE INDEX idx_busqueda_isbn_ejemplar ON EJEMPLAR(isbn);

