SET SERVEROUTPUT ON;

DECLARE
    -- Cursor para obtener la lista de todos los proyectos.
    CURSOR C_PROYECTOS IS
        SELECT ID_PROYECTO, NOMBRE
        FROM PROYECTO
        ORDER BY NOMBRE;

    -- Cursor que busca los estudiantes para un ID de proyecto específico.
    CURSOR C_ESTUDIANTES(P_ID_PROYECTO NUMBER) IS
        SELECT PNOMBRE, PAPELLIDO
        FROM ESTUDIANTE
        WHERE ID_PROYECTO = P_ID_PROYECTO;

    v_tiene_estudiantes BOOLEAN;

BEGIN
    DBMS_OUTPUT.PUT_LINE('--- Listado de Estudiantes por Proyecto ---');

    -- El primer bucle recorre cada proyecto.
    FOR R_PROYECTO IN C_PROYECTOS LOOP
        
        -- IMPRIME EL NOMBRE DEL PROYECTO (Ej: proyecto1)
        DBMS_OUTPUT.PUT_LINE(''); 
        DBMS_OUTPUT.PUT_LINE('> Proyecto: ' || R_PROYECTO.NOMBRE);

        v_tiene_estudiantes := FALSE;

        -- El segundo bucle (anidado) recorre solo los estudiantes de ese proyecto.
        FOR R_ESTUDIANTE IN C_ESTUDIANTES(R_PROYECTO.ID_PROYECTO) LOOP

            -- IMPRIME CADA ESTUDIANTE CON INDENTACIÓN (Ej: - estudiante 1)
            DBMS_OUTPUT.PUT_LINE('  - ' || R_ESTUDIANTE.PNOMBRE || ' ' || R_ESTUDIANTE.PAPELLIDO);
            v_tiene_estudiantes := TRUE;
        END LOOP;

        -- Si un proyecto no tiene estudiantes, lo indica.
        IF NOT v_tiene_estudiantes THEN
            DBMS_OUTPUT.PUT_LINE('  (Sin estudiantes asignados a este proyecto)');
        END IF;

    END LOOP;
END;
/