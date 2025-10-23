SET SERVEROUTPUT ON;

DECLARE
    
    estudiante_sin_proyecto EXCEPTION;

    v_rut_estudiante NUMBER := 19904472; -- Estudiante sin proyecto.
    v_id_evento      NUMBER := 2;
    v_id_proyecto    NUMBER;

BEGIN
    -- Revisa si el estudiante tiene un proyecto asignado.
    SELECT id_proyecto INTO v_id_proyecto
    FROM ESTUDIANTE
    WHERE numrun = v_rut_estudiante;

    -- Si el proyecto es NULL, lanza la excepción personalizada por su nombre.
    IF v_id_proyecto IS NULL THEN
        RAISE estudiante_sin_proyecto;
    END IF;

    -- Si tiene proyecto, lo inscribe (simulación).
    INSERT INTO EVENTO_ESTUDIANTE(id_evento, numrun_estudiante)
    VALUES (v_id_evento, v_rut_estudiante);

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Estudiante inscrito en el evento.');

EXCEPTION
    -- Captura la excepción personalizada por su nombre.
    WHEN estudiante_sin_proyecto THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Error: El estudiante debe tener un proyecto asignado para inscribirse en un evento.');
    -- Es una buena práctica incluir un manejador para otros posibles errores.
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Ha ocurrido un error inesperado: ' || SQLERRM);
END;
/