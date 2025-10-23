CREATE OR REPLACE PROCEDURE P_ASIGNAR_PROYECTO(
    p_rut_estudiante IN NUMBER,
    p_id_proyecto    IN NUMBER
) IS
BEGIN
    UPDATE ESTUDIANTE
    SET id_proyecto = p_id_proyecto
    WHERE numrun = p_rut_estudiante;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Asignación de proyecto exitosa.');

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Ha ocurrido un error inesperado: ' || SQLERRM);
END P_ASIGNAR_PROYECTO;
/

BEGIN
    P_ASIGNAR_PROYECTO(18066191, 101);
END;
/