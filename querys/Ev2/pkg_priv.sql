CREATE OR REPLACE PACKAGE BODY PKG_GESTION_ESTUDIANTES AS

    FUNCTION F_ESTUDIANTE_EXISTE (
        p_rut IN ESTUDIANTE.NUMRUN%TYPE
    ) RETURN BOOLEAN IS
        v_count NUMBER;
    BEGIN
        -- busca al estudiante
        SELECT COUNT(1) INTO v_count FROM ESTUDIANTE WHERE numrun = p_rut;
        
        -- Devuelve true si el conteo es mayor a 0
        RETURN (v_count > 0);
    END F_ESTUDIANTE_EXISTE;

    -- valida si un proyecto existe.
    FUNCTION F_PROYECTO_EXISTE (
        p_id IN PROYECTO.ID_PROYECTO%TYPE
    ) RETURN BOOLEAN IS
        v_count NUMBER;
    BEGIN
        -- busca el proyecto
        SELECT COUNT(1) INTO v_count FROM PROYECTO WHERE id_proyecto = p_id;
        
        RETURN (v_count > 0);
    END F_PROYECTO_EXISTE;

    --Procedimiento Asignar Proyecto
    PROCEDURE P_ASIGNAR_PROYECTO(
        p_rut_estudiante IN ESTUDIANTE.NUMRUN%TYPE,
        p_id_proyecto    IN PROYECTO.ID_PROYECTO%TYPE
    ) IS BEGIN
        IF NOT F_ESTUDIANTE_EXISTE(p_rut_estudiante) THEN
            DBMS_OUTPUT.PUT_LINE('Error [PKG]: El estudiante con RUT ' || p_rut_estudiante || ' no existe.');
            RETURN;
        END IF;

        IF NOT F_PROYECTO_EXISTE(p_id_proyecto) THEN
            DBMS_OUTPUT.PUT_LINE('Error [PKG]: El proyecto con ID ' || p_id_proyecto || ' no existe.');
            RETURN;
        END IF;

        UPDATE ESTUDIANTE
        SET id_proyecto = p_id_proyecto
        WHERE numrun = p_rut_estudiante;
        
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('Asignación exitosa (gestionada por el Paquete).');
        
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            DBMS_OUTPUT.PUT_LINE('Error [PKG] inesperado al asignar: ' || SQLERRM);
    END P_ASIGNAR_PROYECTO;

    --Procedimiento Quitar Proyecto
    PROCEDURE P_QUITAR_PROYECTO(
        p_rut_estudiante IN ESTUDIANTE.NUMRUN%TYPE
    ) IS
    BEGIN

        IF NOT F_ESTUDIANTE_EXISTE(p_rut_estudiante) THEN
            DBMS_OUTPUT.PUT_LINE('Error [PKG]: El estudiante con RUT ' || p_rut_estudiante || ' no existe.');
            RETURN;
        END IF;

        UPDATE ESTUDIANTE
        SET id_proyecto = NULL
        WHERE numrun = p_rut_estudiante;
        
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('Proyecto quitado exitosamente.');

    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            DBMS_OUTPUT.PUT_LINE('Error [PKG] inesperado al quitar: ' || SQLERRM);
    END P_QUITAR_PROYECTO;

END PKG_GESTION_ESTUDIANTES;
/