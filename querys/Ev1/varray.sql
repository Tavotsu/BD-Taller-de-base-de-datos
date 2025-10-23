SET SERVEROUTPUT ON;

DECLARE
    TYPE listado_ruts_type IS VARRAY(200) OF NUMBER;
    asistentes_evento listado_ruts_type;
    v_id_evento NUMBER := 1; -- ID del evento que se quiere consultar.

BEGIN
    -- Es necesario inicializar la colección antes de usarla.
    asistentes_evento := listado_ruts_type();

    -- Recorre el resultado de la consulta y puebla el VARRAY fila por fila.
    FOR registro_asistente IN (
        SELECT numrun_estudiante
        FROM EVENTO_ESTUDIANTE
        WHERE id_evento = v_id_evento
    )
    LOOP
        asistentes_evento.EXTEND;
        asistentes_evento(asistentes_evento.COUNT) := registro_asistente.numrun_estudiante;
    END LOOP;

    -- Finalmente, muestra los RUTs o un mensaje si el VARRAY está vacío.
    IF asistentes_evento.COUNT > 0 THEN
        DBMS_OUTPUT.PUT_LINE('--- Asistentes al Evento ' || v_id_evento || ' ---');
        FOR i IN 1..asistentes_evento.COUNT LOOP
            DBMS_OUTPUT.PUT_LINE('RUT: ' || asistentes_evento(i));
        END LOOP;
    ELSE
        DBMS_OUTPUT.PUT_LINE('Info: El evento ' || v_id_evento || ' no tiene estudiantes asignados.');
    END IF;

END;
/