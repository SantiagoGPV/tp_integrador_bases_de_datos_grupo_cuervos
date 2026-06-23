USE tpIntegradorCuervos;

-- 1. Vista de préstamos activos (Une SOCIO, PRESTAMO, EJEMPLAR y LIBRO)
CREATE OR REPLACE VIEW vw_prestamos_activos AS
SELECT 
    p.id_prestamo,
    CONCAT(s.nombre, ' ', s.apellido) AS nombre_socio,
    s.email AS email_socio,
    l.titulo AS titulo_libro,
    p.fecha_vencimiento,
    DATEDIFF(CURDATE(), p.fecha_vencimiento) AS dias_de_mora
FROM PRESTAMO p
JOIN SOCIO s ON p.id_socio = s.id_socio
JOIN EJEMPLAR e ON p.id_ejemplar = e.id_ejemplar
JOIN LIBRO l ON e.isbn = l.isbn
WHERE p.estado IN ('ACTIVO', 'VENCIDO') AND p.fecha_devolucion IS NULL;

-- 2. Vista de libros disponibles (Trae autores concatenados desde la intermedia)
CREATE OR REPLACE VIEW vw_libros_disponibles AS
SELECT 
    l.isbn, 
    l.titulo, 
    GROUP_CONCAT(CONCAT(a.nombre, ' ', a.apellido) SEPARATOR ', ') AS autor, 
    l.stock_disponible
FROM LIBRO l
JOIN LIBRO_AUTOR la ON l.isbn = la.isbn
JOIN AUTOR a ON la.id_autor = a.id_autor
WHERE l.stock_disponible > 0
GROUP BY l.isbn, l.titulo, l.stock_disponible;

-- 3. Vista de socios suspendidos/sancionados
CREATE OR REPLACE VIEW vw_socios_sancionados AS
SELECT 
    s.id_socio, 
    CONCAT(s.nombre, ' ', s.apellido) AS nombre_socio, 
    s.estado AS estado_actual,
    COUNT(san.id_sancion) AS total_sanciones_historicas
FROM SOCIO s
LEFT JOIN SANCION san ON s.id_socio = san.id_socio
WHERE s.estado = 'SUSPENDIDO'
GROUP BY s.id_socio, s.nombre, s.apellido, s.estado;
