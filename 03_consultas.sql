--Consultas

--Alumnos activos con su plan vigente
-- listar alumnos activos junto con el plan que tienen
--contratado, cantidad de clases y fecha de vencimiento.

SELECT a.ID_Alumno, a.Nombre_Alumno + ' ' + a.Apellido_Alumno as Nombre_Completo,
p.Nombre_Plan, m.Clases_Disponibles, DATEADD(DAY,p.Duracion_Dias, m.Fecha_Inicio) as Fecha_Vencimiento
FROM Alumnos AS a
JOIN Matriculas AS m ON a.ID_Alumno = m.ID_Alumno
JOIN Planes AS p ON p.ID_Plan = m.ID_Plan
WHERE a.Estado_Alumno = 'Activo' AND m.Estado_Matricula = 'Activa'
AND ( DATEADD(DAY,p.Duracion_Dias, m.Fecha_Inicio) >= GETDATE() )


-- Clases disponibles por sede
--mostrar clases que todavía tienen cupo disponible,
--indicando sede, profesor, horario y cupos restantes.

SELECT 
    c.ID_Clase,
    sed.Nombre_Sede,
    c.ID_Profesor,
    s.Cantidad_Reformers AS Cupo_Maximo,
    --Cuento cuántas reservas activas tiene cada clase.
    COUNT(r.ID_Reserva) AS Reservas_Activas,
    s.Cantidad_Reformers - COUNT(r.ID_Reserva) AS Cupos_Restantes
FROM Clases AS c
--Traigo el salón de cada clase para saber sede y cupo.
JOIN Salones AS s
    ON c.ID_Salon = s.ID_Salon
JOIN Sedes as sed
    ON s.ID_Sede = s.ID_Sede
-- LEFT: porque una clase puede no tener reservas todavía.
LEFT JOIN Reservas AS r
    ON c.ID_Clase = r.ID_Clase
   AND r.Fecha_Cancelacion IS NULL
--Traigo reservas activas, pero aunque no haya reservas, la clase sigue apareciendo.
GROUP BY
    c.ID_Clase,
    sed.Nombre_Sede,
    c.ID_Profesor,
    s.Cantidad_Reformers
--Me quedo solo con clases que todavía tienen lugar.
HAVING
    s.Cantidad_Reformers - COUNT(r.ID_Reserva) > 0;

--Motivos de cancelación más frecuente

SELECT
    m.Desc_Motivo,
    contador.Veces
FROM Motivo_Cancelacion AS m
JOIN(
    SELECT
        ID_Motivo_Cancelacion,
        COUNT(ID_Motivo_Cancelacion) as Veces
    FROM Reservas
    WHERE ID_Motivo_Cancelacion IS NOT NULL
    GROUP BY ID_Motivo_Cancelacion
) AS contador
    on m.ID_Motivo_Cancelacion = contador.ID_Motivo_Cancelacion
ORDER BY contador.Veces DESC;
