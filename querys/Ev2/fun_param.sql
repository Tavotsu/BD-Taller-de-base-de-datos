SET SERVEROUTPUT ON;

CREATE OR REPLACE FUNCTION F_CONTAR_ESTUDIANTES_POR_TRACK(
    p_id_track IN TRACK.ID_TRACK%TYPE
) RETURN NUMBER IS
    v_total_estudiantes NUMBER;
BEGIN
    SELECT COUNT(e.numrun)
    INTO v_total_estudiantes
    FROM ESTUDIANTE e
    JOIN PROYECTO p ON e.id_proyecto = p.id_proyecto
    WHERE p.id_track = p_id_track;

    RETURN v_total_estudiantes;

EXCEPTION
    WHEN OTHERS THEN
        RETURN 0;
END F_CONTAR_ESTUDIANTES_POR_TRACK;
/


BEGIN
    DBMS_OUTPUT.PUT_LINE('Estudiantes en Track 1: ' || F_CONTAR_ESTUDIANTES_POR_TRACK(1));
END;
/