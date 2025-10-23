-- El objetivo de este script es crear un trigger que registre en una tabla de log cada vez que se asigne un proyecto a un estudiante que previamente no tenía uno asignado.
-- Ahora, creamos el trigger.
CREATE OR REPLACE TRIGGER trg_logger_asig_proyecto
AFTER UPDATE OF id_proyecto ON ESTUDIANTE
FOR EACH ROW
WHEN (NEW.id_proyecto IS NOT NULL AND OLD.id_proyecto IS NULL)
BEGIN
    -- Inserta un registro en la tabla de log.
    INSERT INTO LOG_ASIGNACIONES (rut_estudiante, id_proyecto)
    VALUES (:NEW.numrun, :NEW.id_proyecto);
END;
/
