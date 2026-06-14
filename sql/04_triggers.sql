USE tpIntegradorCuervos;

DELIMITER //
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


DELIMITER //
-- Recalcula stock_disponible luego de actualizar el prestamo
CREATE TRIGGER trg_actualizar_stock_update
AFTER UPDATE ON prestamo FOR EACH ROW 
BEGIN 
    -- Si el estado cambia a 'DEVUELTO', el libro vuelve a estar en la estantería
    IF OLD.estado != 'DEVUELTO' AND NEW.estado = 'DEVUELTO' THEN  
        UPDATE libro SET stock_disponible = stock_disponible + 1
        WHERE isbn = (SELECT isbn FROM ejemplar WHERE id_ejemplar = NEW.id_ejemplar);
    END IF;
   -- Si el estado pasa de 'DEVUELTO' a 'NOT DEVUELTO'
    IF OLD.estado = 'DEVUELTO' AND NEW.estado != 'DEVUELTO' THEN   
        UPDATE libro 
        SET stock_disponible = stock_disponible - 1
        WHERE isbn = (SELECT isbn FROM ejemplar WHERE id_ejemplar = NEW.id_ejemplar);  -- ('ACTIVO', 'DEVUELTO', 'VENCIDO')
    END IF;
END

DELIMITER ;

--------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------

DELIMITER //
-- Cambia estado del SOCIO a 'SUSPENDIDO' automáticamente.

CREATE TRIGGER trg_estado_socio_after_sancion
AFTER INSERT ON SANCION
FOR EACH ROW
BEGIN
    -- Actualizamos el estado del socio al que se le aplicó la sanción
    UPDATE SOCIO 
    SET estado = 'SUSPENDIDO' 
    WHERE id_socio = NEW.id_socio;
END//



DELIMITER ; 

--------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------
DELIMITER //

-- 1. TRIGGER PARA EL INSERT (AFTER INSERT)
CREATE TRIGGER trg_audit_prestamo_insert
AFTER INSERT ON PRESTAMO
FOR EACH ROW
BEGIN
    INSERT INTO Auditoria_prestamo (id_prestamo, accion, estado_anterior, estado_nuevo, fecha_cambio, usuario_bd)
    VALUES (NEW.id_prestamo, 'INSERT', NULL, NEW.estado, NOW(), USER());
END//

-- 2. TRIGGER PARA EL UPDATE (AFTER UPDATE)
CREATE TRIGGER trg_audit_prestamo_update
AFTER UPDATE ON PRESTAMO
FOR EACH ROW
BEGIN
    INSERT INTO Auditoria_prestamo (id_prestamo, accion, estado_anterior, estado_nuevo, fecha_cambio, usuario_bd)
    VALUES (NEW.id_prestamo, 'UPDATE', OLD.estado, NEW.estado, NOW(), USER());
END//

-- 3. TRIGGER PARA EL DELETE (AFTER DELETE)
CREATE TRIGGER trg_audit_prestamo_delete
AFTER DELETE ON PRESTAMO
FOR EACH ROW
BEGIN
    INSERT INTO Auditoria_prestamo (id_prestamo, accion, estado_anterior, estado_nuevo, fecha_cambio, usuario_bd)
    VALUES (OLD.id_prestamo, 'DELETE', OLD.estado, NULL, NOW(), USER());
END//

DELIMITER ;
