CREATE OR REPLACE FUNCTION contar_estudiantes_por_track(
    p_id_track IN NUMBER
) RETURN NUMBER IS
    v_total_estudiantes NUMBER;
BEGIN
    -- Realiza el conteo de estudiantes en el track.
    SELECT COUNT(*)
    INTO v_total_estudiantes
    FROM ESTUDIANTE e
    JOIN PROYECTO p ON e.id_proyecto = p.id_proyecto
    WHERE p.id_track = p_id_track;

    -- Devuelve el total.
    RETURN v_total_estudiantes;
END;