USE tpIntegradorCuervos;
 
DELIMITER //

-- 1. sp_generar_sancion
-- Crea una sanción proporcional a los días de mora.
CREATE PROCEDURE sp_generar_sancion(
    IN p_id_socio INT, 
    IN p_tipo VARCHAR(50), 
    IN p_dias_mora INT
)
BEGIN
    DECLARE v_dias_castigo INT;
    
   
    SET v_dias_castigo = p_dias_mora * 2;																		-- Calculo de dias de suspencion

    INSERT INTO SANCION (id_socio, tipo, fecha_inicio, fecha_fin, motivo)
    VALUES (
        p_id_socio, 
        p_tipo, 
        CURDATE(), 
        DATE_ADD(CURDATE(), INTERVAL v_dias_castigo DAY), 
        CONCAT('Sanción automática por ', p_dias_mora, ' días de mora.')
    );
END//
-- NOTA: El cambio de estado del SOCIO a 'SUSPENDIDO' será manejado por el trigger 'trg_estado_socio'.
-- solicitado en la sección 4.4 para no duplicar lógica.
-- Lógica de negocio: 2 días de suspensión por cada día de mora (lo inventamos porque no dice nada al respecto de esto).

-- ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- 2. sp_registrar_prestamo
-- Valida sanciones activas, límite de préstamos, disponibilidad del ejemplar. 
-- Registra el préstamo y actualiza stock. Retorna error si alguna condición falla y rollback.
CREATE PROCEDURE sp_registrar_prestamo(
    IN p_id_socio INT, 
    IN p_id_ejemplar INT
)
BEGIN
    DECLARE v_estado_socio VARCHAR(20);
    DECLARE v_cant_prestamos INT;
    DECLARE v_estado_ejemplar VARCHAR(20);

    -- Manejo de errores para que, si algo falla, no se guarde nada a medias (Rollback) 						-- (Recomendado a tener por la IA)
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;

    -- 1. Validar sanciones activas / estado del socio
    SELECT estado 
    INTO v_estado_socio FROM SOCIO WHERE id_socio = p_id_socio;													-- Buscamos estado de socio en especifico
    
    IF v_estado_socio != 'ACTIVO' THEN
        SIGNAL SQLSTATE '45000' 
    	SET MESSAGE_TEXT = 'Error: El socio no está activo o se encuentra suspendido.';
    END IF;

    -- 2. Validar límite de préstamos (máximo 3)
    SELECT COUNT(*) INTO v_cant_prestamos FROM PRESTAMO WHERE id_socio = p_id_socio AND estado = 'ACTIVO';
    IF v_cant_prestamos >= 3 THEN
        SIGNAL SQLSTATE '45000' 
    	SET MESSAGE_TEXT = 'Error: El socio ya alcanzó el límite máximo de 3 préstamos activos simultáneos.';
    END IF;

    -- 3. Validar disponibilidad del ejemplar
    SELECT estado_fisico INTO v_estado_ejemplar FROM EJEMPLAR WHERE id_ejemplar = p_id_ejemplar;
    IF v_estado_ejemplar != 'DISPONIBLE' THEN
        SIGNAL SQLSTATE '45000' 
    	SET MESSAGE_TEXT = 'Error: El ejemplar solicitado no se encuentra disponible para préstamo.';
    END IF;

    -- 4. Registrar el préstamo (Asumimos 14 días de préstamo por defecto)
    INSERT INTO PRESTAMO (id_socio, id_ejemplar, fecha_prestamo, fecha_vencimiento, estado)
    VALUES (p_id_socio, p_id_ejemplar, CURDATE(), DATE_ADD(CURDATE(), INTERVAL 14 DAY), 'ACTIVO');

    -- 5. Actualizar estado del ejemplar
    UPDATE EJEMPLAR 
    SET estado_fisico = 'PRESTADO' 
    WHERE id_ejemplar = p_id_ejemplar;
    
    COMMIT;
END//
-- NOTA: La actualización del stock_disponible de la tabla LIBRO la realizará
-- automáticamente el trigger 'trg_actualizar_stock' (AFTER INSERT en PRESTAMO).

-- ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- 3. sp_registrar_devolucion
-- Registra la devolución, actualiza estado del ejemplar y stock. 
-- Si hay mora, llama a sp_generar_sancion automáticamente. 
CREATE PROCEDURE sp_registrar_devolucion(
    IN p_id_prestamo INT
)
BEGIN
	-- Creamos esqueleto de préstamo
    DECLARE v_id_socio INT;
    DECLARE v_id_ejemplar INT;
    DECLARE v_fecha_vencimiento DATE;
    DECLARE v_estado_prestamo VARCHAR(20);
    DECLARE v_dias_mora INT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION																		-- (Recomendado a tener por la IA)
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;

    -- Obtener datos del préstamo
    SELECT id_socio, id_ejemplar, fecha_vencimiento, estado 
    INTO v_id_socio, v_id_ejemplar, v_fecha_vencimiento, v_estado_prestamo
    FROM PRESTAMO WHERE id_prestamo = p_id_prestamo;

    -- Check por si ya esta devuelto
    IF v_estado_prestamo = 'DEVUELTO' THEN
        SIGNAL SQLSTATE '45000' 
    	SET MESSAGE_TEXT = 'Error: Este préstamo ya fue registrado como devuelto.';
    END IF;

    -- 1. Registrar devolución en la tabla PRESTAMO
    UPDATE PRESTAMO 
    SET fecha_devolucion = CURDATE(), estado = 'DEVUELTO' 
    WHERE id_prestamo = p_id_prestamo;

    -- 2. Actualizar estado del ejemplar a DISPONIBLE
    UPDATE EJEMPLAR 
    SET estado_fisico = 'DISPONIBLE' 
    WHERE id_ejemplar = v_id_ejemplar;

    -- 3. Calcular si hay mora y llamar a sp_generar_sancion si corresponde
    SET v_dias_mora = DATEDIFF(CURDATE(), v_fecha_vencimiento);
    
    IF v_dias_mora > 0 THEN
        CALL sp_generar_sancion(v_id_socio, 'Devolución fuera de término', v_dias_mora);
    END IF;

    COMMIT;
END//

-- ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- 4. sp_renovar_prestamo
-- Extiende fecha de vencimiento si el socio no tiene sanciones y el ejemplar no está reservado.
CREATE PROCEDURE sp_renovar_prestamo(
    IN p_id_prestamo INT
)
BEGIN
	-- Creamos esqueleto de préstamo
    DECLARE v_id_socio INT;
    DECLARE v_estado_socio VARCHAR(20);
    DECLARE v_estado_prestamo VARCHAR(20);
	DECLARE v_fecha_vencimiento DATE;
 	-- Obtener datos del préstamo
    SELECT id_socio, estado, fecha_vencimiento 
    INTO v_id_socio, v_estado_prestamo, v_fecha_vencimiento
    FROM PRESTAMO WHERE id_prestamo = p_id_prestamo;

    -- Validar que el préstamo esté activo o vencido
    IF v_estado_prestamo NOT IN ('ACTIVO', 'VENCIDO') THEN
        SIGNAL SQLSTATE '45000' 
    	SET MESSAGE_TEXT = 'Error: Solo se pueden renovar préstamos en activos o vencidos.';
    END IF;

    -- Validar que el socio no esté suspendido
    SELECT estado INTO v_estado_socio FROM SOCIO WHERE id_socio = v_id_socio;
    IF v_estado_socio = 'SUSPENDIDO' THEN
        SIGNAL SQLSTATE '45000' 
    	SET MESSAGE_TEXT = 'Error: El socio tiene sanciones activas y no puede renovar préstamos.';
    END IF;

    -- Verificar que no hayan pasado más de 14 días desde el vencimiento
    IF DATEDIFF(CURDATE(), v_fecha_vencimiento) > 14 THEN
        SIGNAL SQLSTATE '45000' 
    	SET MESSAGE_TEXT = 'Error: No es posible renovar. El préstamo ha superado el límite de 14 días de vencimiento.';
    END IF;
    
    -- Renovar extendiendo 14 días desde la fecha de vencimiento original
    UPDATE PRESTAMO 
    SET fecha_vencimiento = DATE_ADD(fecha_vencimiento, INTERVAL 14 DAY),
        estado = 'ACTIVO' 
    WHERE id_prestamo = p_id_prestamo;

END// 
-- NOTA: Como es muy comun que las personas se pasen un dia del vencimiento y quieran hacer una renovacion para no ser sancionados 
-- nos parecio interesante agregar una regla de negocio que diga lo siguiente:
-- Un socio podra renovar un prestamo vencido siempre y cuando no hayan pasado mas de 14 dias de su vencimiento
-- Esto flexibiliza el sistema y lo hace menos perjudicial para el socio
-- por esto cuando validamos el estado del prestamo tambien aceptamos "VENCIDO" como estado. Si despues pasa la verificacion de 14 dias se lo permite renovar

DELIMITER ;


-- El DECLARE EXIT HANDLER FOR SQLEXCEPTION
-- Es para la transacción.

-- En MySQL, si ocurre un error dentro de un procedimiento (por ejemplo, una violación de clave foránea, un dato incorrecto, etc.), 
-- el procedimiento podría seguir ejecutándose o dejar la base de datos en un estado inconsistente.

-- ¿Qué hace?: Es como un "seguro de vida". Si cualquier línea de código dentro del BEGIN...END tira un error de tipo SQLEXCEPTION, 
-- el motor salta automáticamente al BEGIN...END del handler.

-- ROLLBACK: Cancela todos los cambios realizados desde que se inició la transacción, dejando los datos como estaban antes.

-- RESIGNAL: Esto es clave. El error original que causó el problema se "esconde" al entrar al handler. Con RESIGNAL, 
-- le decís a MySQL: "Ya hice el rollback, ahora mostrale al usuario el error original para que sepa qué pasó".

-- Si no ponés esto, ante un error, la base de datos podría quedar con el ejemplar marcado como "PRESTADO" pero sin el registro en la tabla PRESTAMO. 




















