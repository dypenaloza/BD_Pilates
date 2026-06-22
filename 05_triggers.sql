/* ============================================================================
   04 - TRIGGERS (2 -> consigna 17.d.ii)
============================================================================ */

USE BD_Pilates;
GO

-- Al reservar, se descuenta una clase de la matricula activa del alumno
CREATE TRIGGER trg_Reservas_DescontarClase
ON Reservas
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE m
    SET m.Clases_Disponibles = m.Clases_Disponibles - 1
    FROM Matriculas m
    JOIN INSERTED i ON i.ID_Alumno = m.ID_Alumno
    WHERE m.Estado_Matricula = 'Activa'
      AND m.Clases_Disponibles > 0;
END;
GO

-- Al registrar asistencia, si el alumno acumula 3+ ausencias se bloquea (Inactivo)
CREATE TRIGGER trg_Reservas_BloquearAlumno
ON Reservas
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE a
    SET a.Estado_Alumno = 'Inactivo'
    FROM Alumnos a
    WHERE a.ID_Alumno IN (SELECT ID_Alumno FROM INSERTED)
      AND (SELECT COUNT(*) FROM Reservas r
           WHERE r.ID_Alumno = a.ID_Alumno AND r.Asistio = 0) >= 3;
END;
GO
