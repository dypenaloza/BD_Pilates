/* ============================================================================
   05 - VISTAS (2 -> consigna 17.d.iii)
============================================================================ */

USE BD_Pilates;
GO

-- Alumnos activos con su plan vigente
CREATE VIEW vAlumnosActivosPlan AS
SELECT a.ID_Alumno, a.Nombre_Alumno, a.Apellido_Alumno,
       p.Nombre_Plan, m.Clases_Disponibles, m.Estado_Matricula
FROM Alumnos a
JOIN Matriculas m ON m.ID_Alumno = a.ID_Alumno
JOIN Planes p     ON p.ID_Plan   = m.ID_Plan
WHERE a.Estado_Alumno = 'Activo' AND m.Estado_Matricula = 'Activa';
GO

-- Ocupacion por clase (reservas activas vs. cupo del salon)
CREATE VIEW vOcupacionClases AS
SELECT c.ID_Clase, c.Nombre_Clase, c.Fecha_Clase,
       s.Nombre_Salon, s.Cantidad_Reformers AS Cupo,
       COUNT(r.ID_Reserva) AS Reservados,
       CAST(100.0 * COUNT(r.ID_Reserva) / s.Cantidad_Reformers AS DECIMAL(5,2)) AS PorcentajeOcupacion
FROM Clases c
JOIN Salones s       ON c.ID_Salon = s.ID_Salon
LEFT JOIN Reservas r ON r.ID_Clase = c.ID_Clase AND r.Fecha_Cancelacion IS NULL
GROUP BY c.ID_Clase, c.Nombre_Clase, c.Fecha_Clase, s.Nombre_Salon, s.Cantidad_Reformers;
GO
