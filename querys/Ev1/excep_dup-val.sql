SET SERVEROUTPUT ON;

DECLARE
    -- Variables para el RUT del estudiante y el ID del evento.
    v_numrun_estudiante NUMBER := 18066191; 
    v_id_evento         NUMBER := 1;        

BEGIN
    -- Se intenta insertar un nuevo registro en la tabla de relación.
    INSERT INTO EVENTO_ESTUDIANTE (id_evento, numrun_estudiante)
    VALUES (v_id_evento, v_numrun_estudiante);

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('¡Éxito! Estudiante con RUT ' || v_numrun_estudiante || ' inscrito correctamente en el evento ' || v_id_evento || '.');

EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Error: El estudiante con RUT ' || v_numrun_estudiante || ' ya se encuentra inscrito en el evento ' || v_id_evento || '.');
    
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Ha ocurrido un error inesperado: ' || SQLERRM);
END;
