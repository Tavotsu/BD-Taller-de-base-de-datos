CREATE OR REPLACE PROCEDURE P_REPORTE_PROYECTOS_VACIOS
IS
    CURSOR cur_proyectos_vacios IS
        SELECT p.id_proyecto, p.nombre
        FROM PROYECTO p
        WHERE NOT EXISTS (
            SELECT 1 
            FROM ESTUDIANTE e 
            WHERE e.id_proyecto = p.id_proyecto
        )
        ORDER BY p.nombre;
        
    v_contador NUMBER := 0;
BEGIN
    DBMS_OUTPUT.PUT_LINE('Reporte de Proyectos Sin Estudiantes');

    FOR rec IN cur_proyectos_vacios LOOP
        DBMS_OUTPUT.PUT_LINE('  ID: ' || rec.id_proyecto || ' - Nombre: ' || rec.nombre);
        v_contador := v_contador + 1;
    END LOOP;

    IF v_contador = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Todos los proyectos tienen al menos un estudiante asignado.');
    END IF;
    
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error al generar el reporte: ' || SQLERRM);
END P_REPORTE_PROYECTOS_VACIOS;
/

BEGIN
    P_REPORTE_PROYECTOS_VACIOS;
END;
/