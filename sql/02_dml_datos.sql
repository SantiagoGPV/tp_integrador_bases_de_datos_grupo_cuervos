USE tpIntegradorCuervos;

-- =================================================================================
-- 1. GÉNEROS (Mínimo 5)
-- =================================================================================
INSERT INTO GENERO (nombre, descripcion) VALUES 
('Ciencia Ficción', 'Obras basadas en futuros posibles y avances científicos.'),
('Fantasía', 'Historias con elementos mágicos y mundos imaginarios.'),
('Terror', 'Ficción diseñada para asustar o perturbar al lector.'),
('Informática', 'Libros técnicos sobre programación y bases de datos.'),
('Filosofía', 'Obras de pensamiento, ética y existencialismo.');

-- =================================================================================
-- 2. AUTORES (Mínimo 10)
-- =================================================================================
INSERT INTO AUTOR (nombre, apellido, nacionalidad) VALUES 
('Isaac', 'Asimov', 'Ruso-Estadounidense'),
('Stephen', 'King', 'Estadounidense'),
('J.R.R.', 'Tolkien', 'Británico'),
('Alan', 'Turing', 'Británico'),
('Friedrich', 'Nietzsche', 'Alemán'),
('Jorge Luis', 'Borges', 'Argentino'),
('Julio', 'Cortázar', 'Argentino'),
('J.K.', 'Rowling', 'Británica'),
('George R.R.', 'Martin', 'Estadounidense'),
('Brandon', 'Sanderson', 'Estadounidense');

-- =================================================================================
-- 3. LIBROS (Mínimo 20)
-- STOCK COHERENTE: Los libros 1 al 10 tendrán sus 3 copias prestadas (disp = 0).
-- Los libros 11 al 20 no tienen préstamos activos (disp = 3).
-- =================================================================================
INSERT INTO LIBRO (isbn, titulo, anio_publicacion, stock_total, stock_disponible) VALUES 
-- Libros sin stock (prestados actualmente)
('978-01', 'Fundación', 1951, 3, 0),
('978-02', 'Yo, Robot', 1950, 3, 0),
('978-03', 'El Resplandor', 1977, 3, 0),
('978-04', 'It (Eso)', 1986, 3, 0),
('978-05', 'El Hobbit', 1937, 3, 0),
('978-06', 'El Señor de los Anillos', 1954, 3, 0),
('978-07', 'Computing Machinery and Intelligence', 1950, 3, 0),
('978-08', 'Así habló Zaratustra', 1883, 3, 0),
('978-09', 'Más allá del bien y del mal', 1886, 3, 0),
('978-10', 'El Aleph', 1949, 3, 0),
-- Libros con stock completo (3 copias en biblioteca)
('978-11', 'Ficciones', 1944, 3, 3),
('978-12', 'Rayuela', 1963, 3, 3),
('978-13', 'Bestiario', 1951, 3, 3),
('978-14', 'Harry Potter y la Piedra Filosofal', 1997, 3, 3),
('978-15', 'Harry Potter y la Cámara Secreta', 1998, 3, 3),
('978-16', 'Juego de Tronos', 1996, 3, 3),
('978-17', 'Choque de Reyes', 1998, 3, 3),
('978-18', 'El Imperio Final', 2006, 3, 3),
('978-19', 'El Pozo de la Ascensión', 2007, 3, 3),
('978-20', 'El Héroe de las Eras', 2008, 3, 3);

-- =================================================================================
-- 4. TABLAS ASOCIATIVAS (LIBRO_AUTOR y LIBRO_GENERO)
-- =================================================================================
-- Asignamos autores a los libros
INSERT INTO LIBRO_AUTOR (isbn, id_autor) VALUES 
('978-01', 1), ('978-02', 1), ('978-03', 2), ('978-04', 2), ('978-05', 3), 
('978-06', 3), ('978-07', 4), ('978-08', 5), ('978-09', 5), ('978-10', 6),
('978-11', 6), ('978-12', 7), ('978-13', 7), ('978-14', 8), ('978-15', 8),
('978-16', 9), ('978-17', 9), ('978-18', 10), ('978-19', 10), ('978-20', 10);

-- Asignamos géneros a los libros
INSERT INTO LIBRO_GENERO (isbn, id_genero) VALUES 
('978-01', 1), ('978-02', 1), ('978-03', 3), ('978-04', 3), ('978-05', 2), 
('978-06', 2), ('978-07', 4), ('978-08', 5), ('978-09', 5), ('978-10', 2),
('978-11', 2), ('978-12', 2), ('978-13', 3), ('978-14', 2), ('978-15', 2),
('978-16', 2), ('978-17', 2), ('978-18', 2), ('978-19', 2), ('978-20', 2);

-- =================================================================================
-- 5. EJEMPLARES (60 copias exactas, 3 por libro)
-- =================================================================================
-- Los ejemplares 1 al 30 están 'PRESTADO' (corresponden a libros 1 a 10).
-- Los ejemplares 31 al 60 están 'DISPONIBLE' (corresponden a libros 11 a 20).
INSERT INTO EJEMPLAR (isbn, nro_ejemplar, estado_fisico) VALUES 
('978-01', 1, 'PRESTADO'), ('978-01', 2, 'PRESTADO'), ('978-01', 3, 'PRESTADO'),
('978-02', 1, 'PRESTADO'), ('978-02', 2, 'PRESTADO'), ('978-02', 3, 'PRESTADO'),
('978-03', 1, 'PRESTADO'), ('978-03', 2, 'PRESTADO'), ('978-03', 3, 'PRESTADO'),
('978-04', 1, 'PRESTADO'), ('978-04', 2, 'PRESTADO'), ('978-04', 3, 'PRESTADO'),
('978-05', 1, 'PRESTADO'), ('978-05', 2, 'PRESTADO'), ('978-05', 3, 'PRESTADO'),
('978-06', 1, 'PRESTADO'), ('978-06', 2, 'PRESTADO'), ('978-06', 3, 'PRESTADO'),
('978-07', 1, 'PRESTADO'), ('978-07', 2, 'PRESTADO'), ('978-07', 3, 'PRESTADO'),
('978-08', 1, 'PRESTADO'), ('978-08', 2, 'PRESTADO'), ('978-08', 3, 'PRESTADO'),
('978-09', 1, 'PRESTADO'), ('978-09', 2, 'PRESTADO'), ('978-09', 3, 'PRESTADO'),
('978-10', 1, 'PRESTADO'), ('978-10', 2, 'PRESTADO'), ('978-10', 3, 'PRESTADO'),
('978-11', 1, 'DISPONIBLE'), ('978-11', 2, 'DISPONIBLE'), ('978-11', 3, 'DISPONIBLE'),
('978-12', 1, 'DISPONIBLE'), ('978-12', 2, 'DISPONIBLE'), ('978-12', 3, 'DISPONIBLE'),
('978-13', 1, 'DISPONIBLE'), ('978-13', 2, 'DISPONIBLE'), ('978-13', 3, 'DISPONIBLE'),
('978-14', 1, 'DISPONIBLE'), ('978-14', 2, 'DISPONIBLE'), ('978-14', 3, 'DISPONIBLE'),
('978-15', 1, 'DISPONIBLE'), ('978-15', 2, 'DISPONIBLE'), ('978-15', 3, 'DISPONIBLE'),
('978-16', 1, 'DISPONIBLE'), ('978-16', 2, 'DISPONIBLE'), ('978-16', 3, 'DISPONIBLE'),
('978-17', 1, 'DISPONIBLE'), ('978-17', 2, 'DISPONIBLE'), ('978-17', 3, 'DISPONIBLE'),
('978-18', 1, 'DISPONIBLE'), ('978-18', 2, 'DISPONIBLE'), ('978-18', 3, 'DISPONIBLE'),
('978-19', 1, 'DISPONIBLE'), ('978-19', 2, 'DISPONIBLE'), ('978-19', 3, 'DISPONIBLE'),
('978-20', 1, 'DISPONIBLE'), ('978-20', 2, 'DISPONIBLE'), ('978-20', 3, 'DISPONIBLE');

-- =================================================================================
-- 6. SOCIOS (30 Socios: 28 activos, 2 suspendidos)
-- =================================================================================
INSERT INTO SOCIO (dni, nombre, apellido, email, fecha_alta, estado) VALUES 
('11111111', 'Juan', 'Pérez', 'juan@mail.com', '2025-01-10', 'ACTIVO'),
('22222222', 'María', 'Gómez', 'maria@mail.com', '2025-01-15', 'ACTIVO'),
('33333333', 'Carlos', 'López', 'carlos@mail.com', '2025-02-20', 'ACTIVO'),
('44444444', 'Ana', 'Martínez', 'ana@mail.com', '2025-03-05', 'ACTIVO'),
('55555555', 'Pedro', 'Rodríguez', 'pedro@mail.com', '2025-03-10', 'ACTIVO'),
('66666666', 'Lucía', 'Fernández', 'lucia@mail.com', '2025-04-12', 'ACTIVO'),
('77777777', 'Jorge', 'García', 'jorge@mail.com', '2025-05-22', 'ACTIVO'),
('88888888', 'Sofía', 'Díaz', 'sofia@mail.com', '2025-06-30', 'ACTIVO'),
('99999999', 'Luis', 'Romero', 'luis@mail.com', '2025-07-14', 'ACTIVO'),
('10101010', 'Marta', 'Alonso', 'marta@mail.com', '2025-08-19', 'ACTIVO'),
('12121212', 'Diego', 'Torres', 'diego@mail.com', '2025-09-01', 'ACTIVO'),
('13131313', 'Elena', 'Ruiz', 'elena@mail.com', '2025-09-15', 'ACTIVO'),
('14141414', 'Pablo', 'Vargas', 'pablo@mail.com', '2025-10-05', 'ACTIVO'),
('15151515', 'Carmen', 'Castro', 'carmen@mail.com', '2025-10-20', 'ACTIVO'),
('16161616', 'Raúl', 'Ortiz', 'raul@mail.com', '2025-11-11', 'ACTIVO'),
('17171717', 'Laura', 'Ramos', 'laura@mail.com', '2025-11-25', 'ACTIVO'),
('18181818', 'Hugo', 'Silva', 'hugo@mail.com', '2025-12-05', 'ACTIVO'),
('19191919', 'Alba', 'Gil', 'alba@mail.com', '2025-12-20', 'ACTIVO'),
('20202020', 'Marcos', 'Molina', 'marcos@mail.com', '2026-01-10', 'ACTIVO'),
('21212121', 'Sara', 'Blanco', 'sara@mail.com', '2026-01-25', 'ACTIVO'),
('23232323', 'David', 'Suárez', 'david@mail.com', '2026-02-14', 'ACTIVO'),
('24242424', 'Paula', 'Muñoz', 'paula@mail.com', '2026-02-28', 'ACTIVO'),
('25252525', 'Javier', 'Rubio', 'javier@mail.com', '2026-03-10', 'ACTIVO'),
('26262626', 'Nuria', 'Sanz', 'nuria@mail.com', '2026-03-22', 'ACTIVO'),
('27272727', 'Mario', 'Iglesias', 'mario@mail.com', '2026-04-05', 'ACTIVO'),
('28282828', 'Clara', 'Cruz', 'clara@mail.com', '2026-04-18', 'ACTIVO'),
('29292929', 'Andrés', 'Reyes', 'andres@mail.com', '2026-05-01', 'ACTIVO'),
('30303030', 'Eva', 'Garrido', 'eva@mail.com', '2026-05-15', 'ACTIVO'),
-- Socios con problemas (suspensiones)
('31313131', 'Tomás', 'Herrera', 'tomas@mail.com', '2026-01-05', 'SUSPENDIDO'),
('32323232', 'Inés', 'Medina', 'ines@mail.com', '2026-01-15', 'SUSPENDIDO');

-- =================================================================================
-- 7. SANCIONES (Para los socios 29 y 30 que están SUSPENDIDOS)
-- =================================================================================
INSERT INTO SANCION (id_socio, tipo, fecha_inicio, fecha_fin, motivo) VALUES 
(29, 'Mora severa', '2026-06-01', '2026-06-30', 'Devolución de ejemplar con 30 días de retraso.'),
(30, 'Pérdida', '2026-06-10', '2026-07-10', 'Extravió el ejemplar y no pagó la reposición.');

-- =================================================================================
-- 8. PRÉSTAMOS (50 Préstamos: 20 Devueltos, 20 Activos, 10 Vencidos)
-- =================================================================================

-- 20 PRÉSTAMOS DEVUELTOS (Usan ejemplares del 31 al 50, que ya están en la biblioteca)
INSERT INTO PRESTAMO (id_socio, id_ejemplar, fecha_prestamo, fecha_vencimiento, fecha_devolucion, estado) VALUES 
(1, 31, '2026-01-05', '2026-01-20', '2026-01-18', 'DEVUELTO'),
(2, 32, '2026-01-10', '2026-01-25', '2026-01-22', 'DEVUELTO'),
(3, 33, '2026-01-15', '2026-01-30', '2026-01-28', 'DEVUELTO'),
(4, 34, '2026-02-01', '2026-02-16', '2026-02-10', 'DEVUELTO'),
(5, 35, '2026-02-05', '2026-02-20', '2026-02-15', 'DEVUELTO'),
(6, 36, '2026-02-10', '2026-02-25', '2026-02-20', 'DEVUELTO'),
(7, 37, '2026-03-01', '2026-03-16', '2026-03-14', 'DEVUELTO'),
(8, 38, '2026-03-05', '2026-03-20', '2026-03-18', 'DEVUELTO'),
(9, 39, '2026-03-10', '2026-03-25', '2026-03-22', 'DEVUELTO'),
(10, 40, '2026-04-01', '2026-04-16', '2026-04-10', 'DEVUELTO'),
(11, 41, '2026-04-05', '2026-04-20', '2026-04-15', 'DEVUELTO'),
(12, 42, '2026-04-10', '2026-04-25', '2026-04-20', 'DEVUELTO'),
(13, 43, '2026-04-15', '2026-04-30', '2026-04-28', 'DEVUELTO'),
(14, 44, '2026-05-01', '2026-05-16', '2026-05-10', 'DEVUELTO'),
(15, 45, '2026-05-05', '2026-05-20', '2026-05-18', 'DEVUELTO'),
(16, 46, '2026-05-10', '2026-05-25', '2026-05-22', 'DEVUELTO'),
(17, 47, '2026-05-15', '2026-05-30', '2026-05-28', 'DEVUELTO'),
(18, 48, '2026-05-20', '2026-06-04', '2026-06-01', 'DEVUELTO'),
(19, 49, '2026-05-22', '2026-06-06', '2026-06-05', 'DEVUELTO'),
(20, 50, '2026-05-25', '2026-06-09', '2026-06-08', 'DEVUELTO');

-- 20 PRÉSTAMOS ACTIVOS (Usan ejemplares del 1 al 20. Fechas de junio, aún no vencen)
INSERT INTO PRESTAMO (id_socio, id_ejemplar, fecha_prestamo, fecha_vencimiento, estado) VALUES 
(1, 1, '2026-06-01', '2026-06-15', 'ACTIVO'),
(2, 2, '2026-06-02', '2026-06-16', 'ACTIVO'),
(3, 3, '2026-06-03', '2026-06-17', 'ACTIVO'),
(4, 4, '2026-06-04', '2026-06-18', 'ACTIVO'),
(5, 5, '2026-06-05', '2026-06-19', 'ACTIVO'),
(6, 6, '2026-06-06', '2026-06-20', 'ACTIVO'),
(7, 7, '2026-06-07', '2026-06-21', 'ACTIVO'),
(8, 8, '2026-06-08', '2026-06-22', 'ACTIVO'),
(9, 9, '2026-06-09', '2026-06-23', 'ACTIVO'),
(10, 10, '2026-06-10', '2026-06-24', 'ACTIVO'),
(11, 11, '2026-06-10', '2026-06-24', 'ACTIVO'),
(12, 12, '2026-06-10', '2026-06-24', 'ACTIVO'),
(13, 13, '2026-06-11', '2026-06-25', 'ACTIVO'),
(14, 14, '2026-06-11', '2026-06-25', 'ACTIVO'),
(15, 15, '2026-06-11', '2026-06-25', 'ACTIVO'),
(16, 16, '2026-06-12', '2026-06-26', 'ACTIVO'),
(17, 17, '2026-06-12', '2026-06-26', 'ACTIVO'),
(18, 18, '2026-06-12', '2026-06-26', 'ACTIVO'),
(19, 19, '2026-06-12', '2026-06-26', 'ACTIVO'),
(20, 20, '2026-06-12', '2026-06-26', 'ACTIVO');

-- 10 PRÉSTAMOS VENCIDOS (Usan ejemplares del 21 al 30. Fechas de mayo, ya pasaron los 14 días)
INSERT INTO PRESTAMO (id_socio, id_ejemplar, fecha_prestamo, fecha_vencimiento, estado) VALUES 
(21, 21, '2026-05-01', '2026-05-15', 'VENCIDO'),
(22, 22, '2026-05-05', '2026-05-19', 'VENCIDO'),
(23, 23, '2026-05-10', '2026-05-24', 'VENCIDO'),
(24, 24, '2026-05-12', '2026-05-26', 'VENCIDO'),
(25, 25, '2026-05-15', '2026-05-29', 'VENCIDO'),
(26, 26, '2026-05-18', '2026-06-01', 'VENCIDO'),
(27, 27, '2026-05-20', '2026-06-03', 'VENCIDO'),
(28, 28, '2026-05-22', '2026-06-05', 'VENCIDO'),
(29, 29, '2026-05-25', '2026-06-08', 'VENCIDO'),
(30, 30, '2026-05-25', '2026-06-08', 'VENCIDO');
