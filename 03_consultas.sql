--Consultas

--1)
--Alumnos activos con su plan vigente
-- listar alumnos activos junto con el plan que tienen
--contratado, cantidad de clases y fecha de vencimiento.

SELECT 
    a.ID_Alumno,
    a.Nombre_Alumno + ' ' + a.Apellido_Alumno as Nombre_Completo,
    p.Nombre_Plan,
    m.Clases_Disponibles,
    DATEADD(DAY,p.Duracion_Dias, m.Fecha_Inicio) as Fecha_Vencimiento
FROM Alumnos AS a
JOIN Matriculas AS m
    ON a.ID_Alumno = m.ID_Alumno
JOIN Planes AS p
    ON p.ID_Plan = m.ID_Plan
WHERE
    a.Estado_Alumno = 'Activo'
    AND m.Estado_Matricula = 'Activa'
    AND ( DATEADD(DAY,p.Duracion_Dias, m.Fecha_Inicio) >= GETDATE() )


--2)
-- Clases disponibles por sede
--mostrar clases que todavía tienen cupo disponible,
--indicando sede, profesor, horario y cupos restantes.

SELECT 
    c.ID_Clase,
    sede.Nombre_Sede,
    c.ID_Profesor,
    s.Cantidad_Reformers AS Cupo_Maximo,
    --Cuento cuántas reservas activas tiene cada clase.
    COUNT(r.ID_Reserva) AS Reservas_Activas,
    s.Cantidad_Reformers - COUNT(r.ID_Reserva) AS Cupos_Restantes
FROM Clases AS c
--Traigo el salón de cada clase para saber sede y cupo.
JOIN Salones AS s
    ON c.ID_Salon = s.ID_Salon
JOIN Sedes as sede
    ON s.ID_Sede = sede.ID_Sede
-- LEFT: porque una clase puede no tener reservas todavía.
LEFT JOIN Reservas AS r
    ON c.ID_Clase = r.ID_Clase
   AND r.Fecha_Cancelacion IS NULL
--Traigo reservas activas, pero aunque no haya reservas, la clase sigue apareciendo.
GROUP BY
    c.ID_Clase,
    sede.Nombre_Sede,
    c.ID_Profesor,
    s.Cantidad_Reformers
--Me quedo solo con clases que todavía tienen lugar.
HAVING
    s.Cantidad_Reformers - COUNT(r.ID_Reserva) > 0;

--3)
--Clases con mayor demanda
--obtener las clases con más reservas totales.

SELECT 
    C.ID_Clase,
    C.Nombre_Clase AS Clase,
    C.Fecha_Clase,
    C.Hora_Inicio,
    C.Hora_Fin,
    --Cuenta los ID de Reserva por que el GROUP BY
    --Ya agrupa según el ID Clase
    COUNT(R.ID_Reserva) AS Total_Reservas_Activas
FROM Clases C
INNER JOIN Reservas R
    --Inner join ya que solo obtenemos las clases que tuvieron reserva
    ON C.ID_Clase = R.ID_Clase
WHERE 
    --Y las reservas no fueron canceladas
    R.Fecha_Cancelacion IS NULL
GROUP BY 
    --Agrupo por clase, pero cuento reservas.
    C.ID_Clase,
    C.Nombre_Clase,
    C.Fecha_Clase,
    C.Hora_Inicio,
    C.Hora_Fin
ORDER BY Total_Reservas_Activas DESC;

--4)
-- Clases con menor demanda
--detectar clases con pocas reservas o baja ocupación.

SELECT 
    C.ID_Clase,
    C.Nombre_Clase AS Clase,
    C.Fecha_Clase,
    C.Hora_Inicio,
    C.Hora_Fin,
    S.Cantidad_Reformers,
    --Misma lógica que el anterior, cuenta por IDReserva ya que se agrupa
    --por IDClase
    COUNT(R.ID_Reserva) AS Total_Reservas,
    --Cast: Convierte el resultado del la cuenta en Decimal(5,2)
    --Sirve para tener una columna que exprese la ocupación como porcentaje
    CAST(COUNT(R.ID_Reserva) * 100.0 / S.Cantidad_Reformers AS DECIMAL(5,2)) AS Porcentaje_Ocupacion
FROM Clases C
JOIN Salones S
    ON C.ID_Salon = S.ID_Salon
--Se hace LEFT JOIN por que puede haber clases sin reservas, importa para
--la baja demanda
LEFT JOIN Reservas R
    ON C.ID_Clase = R.ID_Clase
GROUP BY 
    C.ID_Clase,
    C.Nombre_Clase,
    C.Fecha_Clase,
    C.Hora_Inicio,
    C.Hora_Fin,
    S.Cantidad_Reformers
--Ordeno asc para que primero queden las de más baja ocupación
ORDER BY Porcentaje_Ocupacion ASC;


--5)
--Asistencia por alumno
--calcular cuántas clases asistió, cuántas faltó y cuántas canceló cada alumno

SELECT
    A.ID_Alumno,
    A.Nombre_Alumno,
    A.Apellido_Alumno,
    COUNT(R.ID_Reserva) AS Total_Reservas,
    --Caso 1: Asistió y no canceló
    --Cuando asistió se suma uno, si no asistió no se suma nada
    --Se guarda en Clases_Asistidas
    --(Cómo se agrupa por ID_Alumno, queda cada reserva asociada al alumno)
    SUM(CASE
            WHEN R.Asistio = 1
            THEN 1
            ELSE 0
        END) AS Clases_Asistidas,
    
    --Caso 2: No canceló pero faltó
    SUM(CASE
            WHEN R.Asistio = 0 
             AND R.Fecha_Cancelacion IS NULL
            THEN 1
            ELSE 0
        END) AS Clases_Faltadas,
    --Caso 3: Canceló
    SUM(CASE
            WHEN R.Fecha_Cancelacion IS NOT NULL
            THEN 1
            ELSE 0
        END) AS Clases_Canceladas

FROM Alumnos A
--Left Join por que puede ser que un alumno no haya reservado
LEFT JOIN Reservas R
    ON A.ID_Alumno = R.ID_Alumno

GROUP BY
    A.ID_Alumno,
    A.Nombre_Alumno,
    A.Apellido_Alumno
--Ordenamos por apellido y nombre asi queda alfabético
ORDER BY
    A.Apellido_Alumno,
    A.Nombre_Alumno;



--8)
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
