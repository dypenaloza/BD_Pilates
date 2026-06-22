/* ============================================================================
   03 - PROCEDIMIENTOS DE CRUD (2 por tabla -> consigna 17.b)
   Convencion: sp_<Tabla>_Insert y sp_<Tabla>_Update
============================================================================ */

USE BD_Pilates;
GO

-- ALUMNOS
CREATE PROCEDURE sp_Alumnos_Insert
    @Nombre VARCHAR(25), @Apellido VARCHAR(25), @DNI VARCHAR(10),
    @Telefono VARCHAR(20), @Email VARCHAR(50), @FechaNac DATE, @Estado VARCHAR(15)
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO Alumnos (Nombre_Alumno, Apellido_Alumno, DNI_Alumno, Telefono_Alumno, Email_Alumno, Fecha_Nacimiento, Estado_Alumno)
    VALUES (@Nombre, @Apellido, @DNI, @Telefono, @Email, @FechaNac, @Estado);
END;
GO
CREATE PROCEDURE sp_Alumnos_Update
    @ID INT, @Telefono VARCHAR(20), @Email VARCHAR(50), @Estado VARCHAR(15)
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE Alumnos
    SET Telefono_Alumno = @Telefono, Email_Alumno = @Email, Estado_Alumno = @Estado
    WHERE ID_Alumno = @ID;
END;
GO

-- PROFESORES
CREATE PROCEDURE sp_Profesores_Insert
    @Nombre VARCHAR(25), @Apellido VARCHAR(25), @Telefono VARCHAR(25),
    @Email VARCHAR(50), @Especialidad VARCHAR(25), @Estado VARCHAR(15)
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO Profesores (Nombre_Profesor, Apellido_Profesor, Telefono_Profesor, Email_Profesor, Especialidad, Estado_Profesor)
    VALUES (@Nombre, @Apellido, @Telefono, @Email, @Especialidad, @Estado);
END;
GO
CREATE PROCEDURE sp_Profesores_Update
    @ID INT, @Telefono VARCHAR(25), @Email VARCHAR(50), @Especialidad VARCHAR(25), @Estado VARCHAR(15)
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE Profesores
    SET Telefono_Profesor = @Telefono, Email_Profesor = @Email,
        Especialidad = @Especialidad, Estado_Profesor = @Estado
    WHERE ID_Profesor = @ID;
END;
GO

-- PLANES
CREATE PROCEDURE sp_Planes_Insert
    @Nombre VARCHAR(50), @CantClases INT, @Precio DECIMAL(10,2), @Duracion INT
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO Planes (Nombre_Plan, Cantidad_Clases, Precio_Plan, Duracion_Dias)
    VALUES (@Nombre, @CantClases, @Precio, @Duracion);
END;
GO
CREATE PROCEDURE sp_Planes_Update
    @ID INT, @Precio DECIMAL(10,2), @Duracion INT
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE Planes SET Precio_Plan = @Precio, Duracion_Dias = @Duracion WHERE ID_Plan = @ID;
END;
GO

-- SEDES
CREATE PROCEDURE sp_Sedes_Insert
    @Nombre VARCHAR(25), @Direccion VARCHAR(100), @Telefono VARCHAR(25)
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO Sedes (Nombre_Sede, Direccion_Sede, Telefono_Sede) VALUES (@Nombre, @Direccion, @Telefono);
END;
GO
CREATE PROCEDURE sp_Sedes_Update
    @ID INT, @Direccion VARCHAR(100), @Telefono VARCHAR(25)
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE Sedes SET Direccion_Sede = @Direccion, Telefono_Sede = @Telefono WHERE ID_Sede = @ID;
END;
GO

-- SALONES
CREATE PROCEDURE sp_Salones_Insert
    @ID_Sede INT, @Nombre VARCHAR(25), @Reformers INT
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO Salones (ID_Sede, Nombre_Salon, Cantidad_Reformers) VALUES (@ID_Sede, @Nombre, @Reformers);
END;
GO
CREATE PROCEDURE sp_Salones_Update
    @ID INT, @Nombre VARCHAR(25), @Reformers INT
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE Salones SET Nombre_Salon = @Nombre, Cantidad_Reformers = @Reformers WHERE ID_Salon = @ID;
END;
GO

-- CLASES
CREATE PROCEDURE sp_Clases_Insert
    @ID_Salon INT, @ID_Profesor INT, @Nombre VARCHAR(25),
    @Fecha DATE, @HoraInicio TIME, @HoraFin TIME
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO Clases (ID_Salon, ID_Profesor, Nombre_Clase, Fecha_Clase, Hora_Inicio, Hora_Fin)
    VALUES (@ID_Salon, @ID_Profesor, @Nombre, @Fecha, @HoraInicio, @HoraFin);
END;
GO
CREATE PROCEDURE sp_Clases_Update
    @ID INT, @ID_Profesor INT, @Fecha DATE, @HoraInicio TIME, @HoraFin TIME
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE Clases
    SET ID_Profesor = @ID_Profesor, Fecha_Clase = @Fecha, Hora_Inicio = @HoraInicio, Hora_Fin = @HoraFin
    WHERE ID_Clase = @ID;
END;
GO

-- MOTIVO_CANCELACION
CREATE PROCEDURE sp_MotivoCancelacion_Insert
    @Desc VARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO Motivo_Cancelacion (Desc_Motivo) VALUES (@Desc);
END;
GO
CREATE PROCEDURE sp_MotivoCancelacion_Update
    @ID INT, @Desc VARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE Motivo_Cancelacion SET Desc_Motivo = @Desc WHERE ID_Motivo_Cancelacion = @ID;
END;
GO

-- RESERVAS
CREATE PROCEDURE sp_Reservas_Insert
    @ID_Clase INT, @ID_Alumno INT, @Fecha_Reserva DATETIME
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO Reservas (ID_Clase, ID_Alumno, Fecha_Reserva, Asistio)
    VALUES (@ID_Clase, @ID_Alumno, @Fecha_Reserva, NULL);
END;
GO
CREATE PROCEDURE sp_Reservas_Update
    @ID_Reserva INT, @Asistio BIT, @Observacion VARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE Reservas
    SET Asistio = @Asistio, Observacion_Asistencia = @Observacion, Recupera_Clase = 0
    WHERE ID_Reserva = @ID_Reserva AND Fecha_Cancelacion IS NULL;
END;
GO

-- LISTA_DE_ESPERA
CREATE PROCEDURE sp_ListaEspera_Insert
    @ID_Alumno INT, @ID_Clase INT, @Fecha DATETIME
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO Lista_de_Espera (ID_Alumno, ID_Clase, Fecha_Solicitud, Estado_Lista_Espera)
    VALUES (@ID_Alumno, @ID_Clase, @Fecha, 'Esperando');
END;
GO
CREATE PROCEDURE sp_ListaEspera_Update
    @ID INT, @Estado VARCHAR(15)
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE Lista_de_Espera SET Estado_Lista_Espera = @Estado WHERE ID_Lista_Espera = @ID;
END;
GO

-- MATRICULAS
CREATE PROCEDURE sp_Matriculas_Insert
    @ID_Plan INT, @ID_Alumno INT, @Fecha DATE, @ClasesDisp INT
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO Matriculas (ID_Plan, ID_Alumno, Fecha_Inicio, Clases_Disponibles, Estado_Matricula)
    VALUES (@ID_Plan, @ID_Alumno, @Fecha, @ClasesDisp, 'Activa');
END;
GO
CREATE PROCEDURE sp_Matriculas_Update
    @ID INT, @ClasesDisp INT, @Estado VARCHAR(15)
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE Matriculas SET Clases_Disponibles = @ClasesDisp, Estado_Matricula = @Estado WHERE ID_Matricula = @ID;
END;
GO

-- METODOS_PAGO
CREATE PROCEDURE sp_MetodosPago_Insert
    @Nombre VARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO Metodos_Pago (Nombre_Metodo) VALUES (@Nombre);
END;
GO
CREATE PROCEDURE sp_MetodosPago_Update
    @ID INT, @Nombre VARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE Metodos_Pago SET Nombre_Metodo = @Nombre WHERE ID_Metodo_Pago = @ID;
END;
GO

-- PAGOS
CREATE PROCEDURE sp_Pagos_Insert
    @ID_Matricula INT, @ID_Metodo INT, @Fecha DATE, @Monto DECIMAL(10,2)
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO Pagos (ID_Matricula, ID_Metodo_Pago, Fecha_Pago, Monto_Pago)
    VALUES (@ID_Matricula, @ID_Metodo, @Fecha, @Monto);
END;
GO
CREATE PROCEDURE sp_Pagos_Update
    @ID INT, @ID_Metodo INT, @Monto DECIMAL(10,2)
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE Pagos SET ID_Metodo_Pago = @ID_Metodo, Monto_Pago = @Monto WHERE ID_Pago = @ID;
END;
GO
