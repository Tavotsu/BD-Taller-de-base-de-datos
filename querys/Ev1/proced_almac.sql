CREATE OR REPLACE PROCEDURE asignar_proyecto(
    p_rut_estudiante IN NUMBER,
    p_id_proyecto    IN NUMBER
) IS
BEGIN
    -- Actualiza el proyecto del estudiante.
    UPDATE ESTUDIANTE
    SET id_proyecto = p_id_proyecto
    WHERE numrun = p_rut_estudiante;

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Asignación de proyecto exitosa.');

EXCEPTION
    -- Maneja el error si el proyecto ya está asignado.
    WHEN DUP_VAL_ON_INDEX THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Error: El proyecto ya se encuentra asignado.');
    -- Maneja cualquier otro error.
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Ha ocurrido un error inesperado.');
END;
/