USE tpIntegradorCuervos;

-- Recalcula stock_disponible en LIBRO según el estado del préstamo.
CREATE TRIGGER trg_actualizar_stock_insert
AFTER INSERT ON prestamo FOR EACH ROW 
  BEGIN 
     UPDATE libro SET stock_disponible = stock_disponible - 1
     WHERE isbn = (SELECT isbn FROM ejemplar WHERE id_ejemplar = NEW.id_ejemplar);
     -- EXPLICACIÓN DEL WHERE:
     -- Como la tabla 'prestamo' solo tiene el 'id_ejemplar' (NEW.id_ejemplar),
     -- usamos esa subconsulta para viajar a la tabla 'ejemplar', buscar a qué libro 
     -- pertenece ese ejemplar, bajarnos su 'isbn' y así poder actualizar el libro correcto.
END; 
DELIMITER ;
