SET SERVEROUTPUT ON;
--El objetivo de este bloque PL/SQL es que, al recibir el RUT de un estudiante, 
--te devuelva un solo record con su nombre completo, 
--el nombre del proyecto en el que participa y el nombre del track de ese proyecto.
DECLARE
    -- Define un tipo de dato RECORD para almacenar la ficha del estudiante.
    TYPE ficha_estudiante_type IS RECORD (
        nombre_completo VARCHAR2(200),
        nombre_proyecto VARCHAR2(150),
        nombre_track    VARCHAR2(100)
    );

    -- Declara una variable del tipo RECORD.
    ficha_estudiante ficha_estudiante_type;

    -- RUT del estudiante que se quiere consultar.
    v_rut_estudiante NUMBER := 21689802;

BEGIN
    -- Realiza la consulta para llenar el RECORD.
    SELECT
        E.PNOMBRE || ' ' || E.SNOMBRE || ' ' || E.PAPELLIDO || ' ' || E.MAPELLIDO,
        P.NOMBRE,
        T.NOMBRE
    INTO FICHA_ESTUDIANTE
    FROM ESTUDIANTE E
    LEFT JOIN PROYECTO P ON E.ID_PROYECTO = P.ID_PROYECTO
    LEFT JOIN TRACK T ON P.ID_TRACK = T.ID_TRACK
    WHERE E.NUMRUN = V_RUT_ESTUDIANTE;

    -- Muestra la información de la ficha.
    DBMS_OUTPUT.PUT_LINE('--- Ficha del Estudiante ---');
    DBMS_OUTPUT.PUT_LINE('Nombre: ' || ficha_estudiante.nombre_completo);
    DBMS_OUTPUT.PUT_LINE('Proyecto: ' || NVL(ficha_estudiante.nombre_proyecto, 'Sin proyecto asignado'));
    DBMS_OUTPUT.PUT_LINE('Track: ' || NVL(ficha_estudiante.nombre_track, 'N/A'));

EXCEPTION
    -- Maneja el caso en que el estudiante no se encuentre.
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Error: No se encontró un estudiante con el RUT ' || v_rut_estudiante);
END;
/