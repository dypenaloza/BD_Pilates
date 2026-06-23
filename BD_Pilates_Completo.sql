/* ============================================================================
   TP INTEGRADOR - INGENIERIA DE DATOS I
   Sistema de gestion para estudio de pilates con multiples sedes
   Motor: Microsoft SQL Server / T-SQL

   Script unico y ejecutable de principio a fin. Orden:
     00  CREATE DATABASE / USE
     01  CREATE TABLE (12 tablas, 3FN)            -> base del grupo
     02  INSERTs (datos de prueba, >=10 por tabla)-> base del grupo + completados
     03  Procedimientos de CRUD (2 por tabla)     -> consigna 17.b
     04  Triggers (2)                             -> consigna 17.d.ii
     05  Vistas (2)                               -> consigna 17.d.iii
     06  Funcion + SP de negocio                  -> consigna 17.d.iv
     07  Consultas (10)                           -> consigna 17.d.i
============================================================================ */

/* ============================================================================
   00 - CREACION DE LA BASE DE DATOS
============================================================================ */
IF DB_ID('BD_Pilates') IS NULL
    CREATE DATABASE BD_Pilates;
GO
USE BD_Pilates;
GO

/* ============================================================================
   01 - CREACION DE TABLAS
============================================================================ */

CREATE TABLE Alumnos (
    ID_Alumno         INT IDENTITY(100,1) NOT NULL,
    Nombre_Alumno     VARCHAR(25)  NOT NULL,
    Apellido_Alumno   VARCHAR(25)  NOT NULL,
    DNI_Alumno        VARCHAR(10)  NOT NULL,
    Telefono_Alumno   VARCHAR(20)  NOT NULL,
    Email_Alumno      VARCHAR(50)  NOT NULL,
    Fecha_Nacimiento  DATE         NOT NULL,
    Estado_Alumno     VARCHAR(15)  NOT NULL,
    CONSTRAINT PK_Alumnos PRIMARY KEY (ID_Alumno),
    CONSTRAINT CK_Alumnos_Estado CHECK (Estado_Alumno IN ('Activo','Inactivo')),
    CONSTRAINT UQ_Alumnos_DNI UNIQUE (DNI_Alumno),
    CONSTRAINT CK_Dni_Alumno CHECK (LEN(DNI_Alumno) >= 8),
    CONSTRAINT CK_FechaNacimiento CHECK (Fecha_Nacimiento > '1930-01-01')
);
GO

CREATE TABLE Profesores (
    ID_Profesor        INT IDENTITY(100,1) NOT NULL,
    Nombre_Profesor    VARCHAR(25)  NOT NULL,
    Apellido_Profesor  VARCHAR(25)  NOT NULL,
    Telefono_Profesor  VARCHAR(25)  NOT NULL,
    Email_Profesor     VARCHAR(50)  NOT NULL,
    Especialidad       VARCHAR(25)  NOT NULL,
    Estado_Profesor    VARCHAR(15)  NOT NULL,
    CONSTRAINT PK_Profesores PRIMARY KEY (ID_Profesor),
    CONSTRAINT UQ_Profesores_Email UNIQUE (Email_Profesor),
    CONSTRAINT UQ_Profesores_Telefono UNIQUE (Telefono_Profesor),
    CONSTRAINT CK_Profesores_Estado CHECK (Estado_Profesor IN ('Activo','Inactivo'))
);
GO

CREATE TABLE Planes (
    ID_Plan          INT IDENTITY(1,1) NOT NULL,
    Nombre_Plan      VARCHAR(50)   NOT NULL,
    Cantidad_Clases  INT           NOT NULL,
    Precio_Plan      DECIMAL(10,2) NOT NULL,
    Duracion_Dias    INT           NOT NULL,
    CONSTRAINT PK_Planes PRIMARY KEY (ID_Plan),
    CONSTRAINT UQ_Planes_NombrePlan UNIQUE (Nombre_Plan),
    CONSTRAINT CK_Planes_CantidadClases CHECK (Cantidad_Clases > 0),
    CONSTRAINT CK_Planes_PrecioPlan CHECK (Precio_Plan > 0),
    CONSTRAINT CK_Planes_DuracionDias CHECK (Duracion_Dias > 0)
);
GO

CREATE TABLE Sedes (
    ID_Sede         INT IDENTITY(100,1) NOT NULL,
    Nombre_Sede     VARCHAR(25)  NOT NULL,
    Direccion_Sede  VARCHAR(100) NOT NULL,
    Telefono_Sede   VARCHAR(25)  NOT NULL,
    CONSTRAINT PK_Sedes PRIMARY KEY (ID_Sede),
    CONSTRAINT UQ_Sedes_NombreDireccion UNIQUE (Nombre_Sede, Direccion_Sede)
);
GO

CREATE TABLE Salones (
    ID_Salon           INT IDENTITY(1,1) NOT NULL,
    ID_Sede            INT NOT NULL,
    Nombre_Salon       VARCHAR(25) NOT NULL,
    Cantidad_Reformers INT NOT NULL,
    CONSTRAINT PK_Salones PRIMARY KEY (ID_Salon),
    CONSTRAINT FK_Salones_Sedes FOREIGN KEY (ID_Sede) REFERENCES Sedes(ID_Sede),
    CONSTRAINT UQ_Salones_NombreSalon UNIQUE (ID_Sede, Nombre_Salon),
    CONSTRAINT CK_Salones_CantReformers CHECK (Cantidad_Reformers > 0)
);
GO

CREATE TABLE Clases (
    ID_Clase      INT IDENTITY(1000,1) NOT NULL,
    ID_Salon      INT NOT NULL,
    ID_Profesor   INT NOT NULL,
    Nombre_Clase  VARCHAR(25) NOT NULL,
    Fecha_Clase   DATE NOT NULL,
    Hora_Inicio   TIME NOT NULL,
    Hora_Fin      TIME NOT NULL,
    CONSTRAINT PK_Clases PRIMARY KEY (ID_Clase),
    CONSTRAINT FK_Clases_Salon FOREIGN KEY (ID_Salon) REFERENCES Salones(ID_Salon),
    CONSTRAINT FK_Clases_Profesor FOREIGN KEY (ID_Profesor) REFERENCES Profesores(ID_Profesor),
    CONSTRAINT CK_Clases_HoraInicioFin CHECK (Hora_Inicio < Hora_Fin),
    CONSTRAINT UQ_Clases_SalonFechaHora UNIQUE (ID_Salon, Fecha_Clase, Hora_Inicio),
    CONSTRAINT UQ_Clases_ProfesorSalonHora UNIQUE (ID_Profesor, Fecha_Clase, Hora_Inicio)
);
GO

CREATE TABLE Motivo_Cancelacion (
    ID_Motivo_Cancelacion INT IDENTITY(1,1) NOT NULL,
    Desc_Motivo           VARCHAR(100) NOT NULL,
    CONSTRAINT PK_Motivo_Cancelacion PRIMARY KEY (ID_Motivo_Cancelacion),
    CONSTRAINT UQ_MotivoCancelacion_DescMotivo UNIQUE (Desc_Motivo)
);
GO

CREATE TABLE Reservas (
    ID_Reserva             INT IDENTITY(1000,1) NOT NULL,
    ID_Clase               INT NOT NULL,
    ID_Alumno              INT NOT NULL,
    ID_Motivo_Cancelacion  INT NULL,
    Fecha_Reserva          DATETIME NOT NULL,
    Asistio                BIT NULL,
    Observacion_Asistencia VARCHAR(100) NULL,
    Fecha_Cancelacion      DATETIME NULL,
    Recupera_Clase         BIT NULL,
    CONSTRAINT PK_Reservas PRIMARY KEY (ID_Reserva),
    CONSTRAINT FK_Reservas_Clase FOREIGN KEY (ID_Clase) REFERENCES Clases(ID_Clase),
    CONSTRAINT FK_Reservas_Alumno FOREIGN KEY (ID_Alumno) REFERENCES Alumnos(ID_Alumno),
    CONSTRAINT FK_Reservas_MotivoCancelacion FOREIGN KEY (ID_Motivo_Cancelacion) REFERENCES Motivo_Cancelacion(ID_Motivo_Cancelacion),
    CONSTRAINT CK_Reservas_FechaReservaCancelacion CHECK (Fecha_Cancelacion IS NULL OR Fecha_Reserva <= Fecha_Cancelacion),
    CONSTRAINT CK_Reservas_CancelacionCompleta CHECK
    (
        (Fecha_Cancelacion IS NULL AND ID_Motivo_Cancelacion IS NULL)
        OR
        (Fecha_Cancelacion IS NOT NULL AND ID_Motivo_Cancelacion IS NOT NULL)
    ),
    CONSTRAINT CK_Reservas_CancelacionAsistencia CHECK
    (Fecha_Cancelacion IS NULL OR Asistio IS NULL),
    CONSTRAINT UQ_Reservas_AlumnoClase UNIQUE (ID_Alumno, ID_Clase),
    CONSTRAINT CK_Reservas_RecuperaClase_Logica CHECK (
        -- Canceló: no asiste (null) y debe quedar definido si recupera
        (Fecha_Cancelacion IS NOT NULL AND Asistio IS NULL AND Recupera_Clase IS NOT NULL)
        OR
        -- No canceló y aun no se tomo lista
        (Fecha_Cancelacion IS NULL AND Asistio IS NULL AND Recupera_Clase IS NULL)
        OR
        -- No canceló y ya se registro asistencia
        (Fecha_Cancelacion IS NULL AND Asistio IS NOT NULL AND Recupera_Clase = 0)
    )
);
GO

CREATE TABLE Lista_de_Espera (
    ID_Lista_Espera     INT IDENTITY(1000,1) NOT NULL,
    ID_Alumno           INT NOT NULL,
    ID_Clase            INT NOT NULL,
    Fecha_Solicitud     DATETIME NOT NULL,
    Estado_Lista_Espera VARCHAR(15) NOT NULL,
    CONSTRAINT PK_ListaEspera PRIMARY KEY (ID_Lista_Espera),
    CONSTRAINT FK_ListaEspera_Alumno FOREIGN KEY (ID_Alumno) REFERENCES Alumnos(ID_Alumno),
    CONSTRAINT FK_ListaEspera_Clase FOREIGN KEY (ID_Clase) REFERENCES Clases(ID_Clase),
    CONSTRAINT UQ_ListaEspera_AlumnoClase UNIQUE (ID_Alumno, ID_Clase),
    CONSTRAINT CK_ListaEspera_Estado CHECK (Estado_Lista_Espera IN ('Reservado','Esperando'))
);
GO

CREATE TABLE Matriculas (
    ID_Matricula       INT IDENTITY(1000,1) NOT NULL,
    ID_Plan            INT NOT NULL,
    ID_Alumno          INT NOT NULL,
    Fecha_Inicio       DATE NOT NULL,
    Clases_Disponibles INT NOT NULL,
    Estado_Matricula   VARCHAR(15) NOT NULL,
    CONSTRAINT PK_Matriculas PRIMARY KEY (ID_Matricula),
    CONSTRAINT FK_Matriculas_Planes FOREIGN KEY (ID_Plan) REFERENCES Planes(ID_Plan),
    CONSTRAINT FK_Matriculas_Alumnos FOREIGN KEY (ID_Alumno) REFERENCES Alumnos(ID_Alumno),
    CONSTRAINT CK_Matriculas_ClasesDisp CHECK (Clases_Disponibles >= 0),
    CONSTRAINT CK_Matriculas_Estado CHECK (Estado_Matricula IN ('Activa','Inactiva'))
);
GO

CREATE TABLE Metodos_Pago (
    ID_Metodo_Pago INT IDENTITY(1,1) NOT NULL,
    Nombre_Metodo  VARCHAR(50) NOT NULL,
    CONSTRAINT PK_MetodosPago PRIMARY KEY (ID_Metodo_Pago),
    CONSTRAINT UQ_MetodosPago_Nombre UNIQUE (Nombre_Metodo)
);
GO

CREATE TABLE Pagos (
    ID_Pago        INT IDENTITY(1000,1) NOT NULL,
    ID_Matricula   INT NOT NULL,
    ID_Metodo_Pago INT NOT NULL,
    Fecha_Pago     DATE NOT NULL,
    Monto_Pago     DECIMAL(10,2) NOT NULL,
    CONSTRAINT PK_Pagos PRIMARY KEY (ID_Pago),
    CONSTRAINT FK_Pagos_Matriculas FOREIGN KEY (ID_Matricula) REFERENCES Matriculas(ID_Matricula),
    CONSTRAINT FK_Pagos_Metodo FOREIGN KEY (ID_Metodo_Pago) REFERENCES Metodos_Pago(ID_Metodo_Pago),
    CONSTRAINT CK_Pagos_Monto CHECK (Monto_Pago > 0)
);
GO

/* ============================================================================
   02 - INSERCION DE DATOS DE PRUEBA (>= 10 por tabla; lookups 3-5)
============================================================================ */

-- SEDES (lookup)
INSERT INTO Sedes (Nombre_Sede, Direccion_Sede, Telefono_Sede) VALUES
('Sede Centro',   'Av. Corrientes 1234', '1145556001'),
('Sede Palermo',  'Av. Santa Fe 4500',   '1145556002'),
('Sede Belgrano', 'Av. Cabildo 2100',    '1145556003');
GO

-- SALONES (ID_Sede: 100=Centro, 101=Palermo, 102=Belgrano)
INSERT INTO Salones (ID_Sede, Nombre_Salon, Cantidad_Reformers) VALUES
(100, 'Salon A', 8),
(100, 'Salon B', 6),
(101, 'Salon A', 10),
(101, 'Salon B', 8),
(102, 'Salon Unico', 6);
GO

-- PROFESORES (10)
INSERT INTO Profesores (Nombre_Profesor, Apellido_Profesor, Telefono_Profesor, Email_Profesor, Especialidad, Estado_Profesor) VALUES
('Carla',     'Gomez',     '1156667001', 'carla.gomez@bdpilates.com',     'Pilates Mat',         'Activo'),
('Martin',    'Perez',     '1156667002', 'martin.perez@bdpilates.com',    'Pilates Reformer',    'Activo'),
('Lucia',     'Fernandez', '1156667003', 'lucia.fernandez@bdpilates.com', 'Pilates Terapeutico', 'Activo'),
('Diego',     'Sosa',      '1156667004', 'diego.sosa@bdpilates.com',      'Pilates Reformer',    'Inactivo'),
('Paula',     'Gimenez',   '1156667005', 'paula.gimenez@bdpilates.com',   'Pilates Mat',         'Activo'),
('Andres',    'Molina',    '1156667006', 'andres.molina@bdpilates.com',   'Pilates Reformer',    'Activo'),
('Florencia', 'Castro',    '1156667007', 'florencia.castro@bdpilates.com','Pilates Terapeutico', 'Activo'),
('Gabriel',   'Ruiz',      '1156667008', 'gabriel.ruiz@bdpilates.com',    'Pilates Mat',         'Activo'),
('Marina',    'Vega',      '1156667009', 'marina.vega@bdpilates.com',     'Pilates Reformer',    'Inactivo'),
('Hernan',    'Diaz',      '1156667010', 'hernan.diaz@bdpilates.com',     'Pilates Mat',         'Activo');
GO

-- PLANES (lookup)
INSERT INTO Planes (Nombre_Plan, Cantidad_Clases, Precio_Plan, Duracion_Dias) VALUES
('Plan 8 clases',              8,  12000.00, 30),
('Plan 12 clases',             12, 16000.00, 30),
('Plan Ilimitado',             30, 22000.00, 30),
('Plan Trimestral 24 clases',  24, 40000.00, 90);
GO

-- ALUMNOS (10)
INSERT INTO Alumnos (Nombre_Alumno, Apellido_Alumno, DNI_Alumno, Telefono_Alumno, Email_Alumno, Fecha_Nacimiento, Estado_Alumno) VALUES
('Sofia',     'Ramirez', '30111222', '1167778001', 'sofia.ramirez@mail.com',   '1992-03-14', 'Activo'),
('Juan',      'Torres',  '28222333', '1167778002', 'juan.torres@mail.com',     '1988-07-22', 'Activo'),
('Valentina', 'Diaz',    '35333444', '1167778003', 'valentina.diaz@mail.com',  '1995-11-02', 'Activo'),
('Mateo',     'Lopez',   '32444555', '1167778004', 'mateo.lopez@mail.com',     '1990-01-30', 'Activo'),
('Camila',    'Suarez',  '31555666', '1167778005', 'camila.suarez@mail.com',   '1993-05-18', 'Activo'),
('Tomas',     'Acosta',  '29666777', '1167778006', 'tomas.acosta@mail.com',    '1991-09-09', 'Inactivo'),
('Lucia',     'Romero',  '33777888', '1167778007', 'lucia.romero@mail.com',    '1996-12-25', 'Activo'),
('Nicolas',   'Herrera', '34888999', '1167778008', 'nicolas.herrera@mail.com', '1994-04-04', 'Activo'),
('Brenda',    'Molina',  '36888111', '1167778009', 'brenda.molina@mail.com',   '1998-02-10', 'Activo'),
('Federico',  'Rios',    '37999222', '1167778010', 'federico.rios@mail.com',   '1999-08-21', 'Activo');
GO

-- CLASES (10)  Salon: 1=CentroA,2=CentroB,3=PalermoA,4=PalermoB,5=Belgrano | Prof: 100=Carla,101=Martin,102=Lucia,103=Diego
INSERT INTO Clases (ID_Salon, ID_Profesor, Nombre_Clase, Fecha_Clase, Hora_Inicio, Hora_Fin) VALUES
(1, 100, 'Pilates Mat',         '2026-06-10', '08:00', '09:00'),
(2, 101, 'Pilates Reformer',    '2026-06-12', '09:00', '10:00'),
(3, 102, 'Pilates Terapeutico', '2026-06-15', '10:00', '11:00'),
(5, 103, 'Pilates Reformer',    '2026-06-17', '19:00', '20:00'),
(1, 100, 'Pilates Mat',         '2026-06-22', '08:00', '09:00'),
(2, 101, 'Pilates Reformer',    '2026-06-23', '09:00', '10:00'),
(3, 102, 'Pilates Terapeutico', '2026-06-24', '10:00', '11:00'),
(4, 101, 'Pilates Reformer',    '2026-06-25', '18:00', '19:00'),
(5, 102, 'Pilates Terapeutico', '2026-06-26', '19:00', '20:00'),
(2, 100, 'Pilates Mat',         '2026-06-27', '18:00', '19:00');
GO

-- MOTIVO_CANCELACION (lookup)
INSERT INTO Motivo_Cancelacion (Desc_Motivo) VALUES
('Enfermedad'),
('Motivos laborales'),
('Viaje'),
('Falta de tiempo');
GO

-- MATRICULAS (10)  Plan: 1=Plan8,2=Plan12,3=Ilimitado,4=Trimestral
INSERT INTO Matriculas (ID_Plan, ID_Alumno, Fecha_Inicio, Clases_Disponibles, Estado_Matricula) VALUES
(2, 100, '2026-06-01', 9,  'Activa'),    -- Sofia
(3, 101, '2026-06-01', 25, 'Activa'),    -- Juan
(1, 102, '2026-06-05', 5,  'Activa'),    -- Valentina
(4, 103, '2026-05-15', 18, 'Activa'),    -- Mateo
(2, 104, '2026-06-10', 12, 'Activa'),    -- Camila
(1, 105, '2026-05-01', 2,  'Inactiva'),  -- Tomas
(3, 106, '2026-06-01', 28, 'Activa'),    -- Lucia
(1, 107, '2026-06-15', 8,  'Activa'),    -- Nicolas
(1, 108, '2026-06-12', 8,  'Activa'),    -- Brenda
(2, 109, '2026-06-14', 12, 'Activa');    -- Federico
GO

-- METODOS_PAGO (lookup)
INSERT INTO Metodos_Pago (Nombre_Metodo) VALUES
('Efectivo'),
('Tarjeta de Debito'),
('Tarjeta de Credito'),
('Transferencia');
GO

-- PAGOS (10)  Matricula: 1000..1009 | Metodo: 1=Efectivo,2=Debito,3=Credito,4=Transferencia
INSERT INTO Pagos (ID_Matricula, ID_Metodo_Pago, Fecha_Pago, Monto_Pago) VALUES
(1000, 3, '2026-06-01', 16000.00),  -- Sofia
(1001, 4, '2026-06-01', 22000.00),  -- Juan
(1002, 1, '2026-06-05', 12000.00),  -- Valentina
(1003, 2, '2026-05-15', 40000.00),  -- Mateo
(1004, 3, '2026-06-10', 16000.00),  -- Camila
(1005, 1, '2026-05-01', 12000.00),  -- Tomas
(1006, 4, '2026-06-01', 22000.00),  -- Lucia
(1007, 2, '2026-06-15', 12000.00),  -- Nicolas
(1008, 2, '2026-06-12', 12000.00),  -- Brenda
(1009, 4, '2026-06-14', 16000.00);  -- Federico
GO

-- RESERVAS  (clases 1000-1003 ya pasaron; 1004-1009 a futuro)
-- Tomas (105) falta a 3 clases seguidas -> coherente con su estado Inactivo
-- Clase 1000
INSERT INTO Reservas (ID_Clase, ID_Alumno, Fecha_Reserva, Asistio, Observacion_Asistencia, Recupera_Clase) VALUES
(1000, 100, '2026-06-08 10:00', 1, NULL, 0),
(1000, 105, '2026-06-08 11:00', 0, 'No se presento', 0);
-- Clase 1001
INSERT INTO Reservas (ID_Clase, ID_Alumno, Fecha_Reserva, Asistio, Observacion_Asistencia, Recupera_Clase) VALUES
(1001, 102, '2026-06-10 09:00', 1, NULL, 0),
(1001, 105, '2026-06-10 09:30', 0, 'No se presento', 0);
-- Clase 1002
INSERT INTO Reservas (ID_Clase, ID_Alumno, Fecha_Reserva, Asistio, Observacion_Asistencia, Recupera_Clase) VALUES
(1002, 104, '2026-06-13 12:00', 1, NULL, 0),
(1002, 105, '2026-06-13 12:30', 0, 'No se presento', 0);
-- Clase 1003 (Lucia cancela con motivo -> puede recuperar)
INSERT INTO Reservas (ID_Clase, ID_Alumno, Fecha_Reserva, Asistio, Observacion_Asistencia, Recupera_Clase) VALUES
(1003, 107, '2026-06-15 08:00', 1, NULL, 0);
INSERT INTO Reservas (ID_Clase, ID_Alumno, Fecha_Reserva, Asistio, ID_Motivo_Cancelacion, Fecha_Cancelacion, Recupera_Clase) VALUES
(1003, 106, '2026-06-14 09:00', NULL, 2, '2026-06-16 14:00', 1);
-- Clases a futuro (Asistio = NULL)
INSERT INTO Reservas (ID_Clase, ID_Alumno, Fecha_Reserva, Asistio) VALUES
(1004, 100, '2026-06-19 09:00', NULL),
(1004, 101, '2026-06-19 09:10', NULL),
(1005, 102, '2026-06-19 09:20', NULL),
(1005, 103, '2026-06-19 09:30', NULL),
(1006, 104, '2026-06-19 09:40', NULL),
(1006, 107, '2026-06-19 09:50', NULL),
(1007, 100, '2026-06-19 10:00', NULL),
(1008, 103, '2026-06-19 10:10', NULL),
(1009, 101, '2026-06-19 10:20', NULL);
GO

-- LISTA_DE_ESPERA (10)
INSERT INTO Lista_de_Espera (ID_Alumno, ID_Clase, Fecha_Solicitud, Estado_Lista_Espera) VALUES
(106, 1005, '2026-06-18', 'Esperando'),
(100, 1006, '2026-06-19', 'Esperando'),
(102, 1009, '2026-06-19', 'Esperando'),
(101, 1006, '2026-06-19', 'Esperando'),
(103, 1009, '2026-06-19', 'Esperando'),
(108, 1005, '2026-06-19', 'Esperando'),
(109, 1006, '2026-06-19', 'Esperando'),
(104, 1005, '2026-06-20', 'Esperando'),
(107, 1009, '2026-06-20', 'Esperando'),
(105, 1006, '2026-06-20', 'Esperando');
GO

/* ============================================================================
   03 - PROCEDIMIENTOS DE CRUD (2 por tabla -> consigna 17.b)
   Convencion: sp_<Tabla>_Insert y sp_<Tabla>_Update
============================================================================ */

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

/* ============================================================================
   04 - TRIGGERS (2 -> consigna 17.d.ii)
============================================================================ */

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

/* ============================================================================
   05 - VISTAS (2 -> consigna 17.d.iii)
============================================================================ */

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

/* ============================================================================
   06 - FUNCION + SP DE NEGOCIO (1 + 1 -> consigna 17.d.iv)
============================================================================ */

-- Funcion escalar: porcentaje de ocupacion de una clase
CREATE FUNCTION dbo.fn_PorcentajeOcupacion (@ID_Clase INT)
RETURNS DECIMAL(5,2)
AS
BEGIN
    DECLARE @Cupo INT, @Reservados INT;
    SELECT @Cupo = s.Cantidad_Reformers
    FROM Clases c JOIN Salones s ON c.ID_Salon = s.ID_Salon
    WHERE c.ID_Clase = @ID_Clase;

    SELECT @Reservados = COUNT(*)
    FROM Reservas
    WHERE ID_Clase = @ID_Clase AND Fecha_Cancelacion IS NULL;

    IF @Cupo IS NULL OR @Cupo = 0 RETURN 0;
    RETURN CAST(100.0 * @Reservados / @Cupo AS DECIMAL(5,2));
END;
GO

-- SP de negocio: registrar una reserva con validacion y transaccion (TRY/CATCH)
CREATE PROCEDURE sp_RegistrarReserva
    @ID_Clase INT,
    @ID_Alumno INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;
            -- Validar clases disponibles
            IF NOT EXISTS (SELECT 1 FROM Matriculas
                           WHERE ID_Alumno = @ID_Alumno
                             AND Estado_Matricula = 'Activa'
                             AND Clases_Disponibles > 0)
            BEGIN
                RAISERROR('El alumno no tiene clases disponibles o matricula activa', 16, 1);
                ROLLBACK TRANSACTION;
                RETURN;
            END;

            -- Validar cupo de la clase
            IF dbo.fn_PorcentajeOcupacion(@ID_Clase) >= 100
            BEGIN
                RAISERROR('La clase no tiene cupo disponible', 16, 1);
                ROLLBACK TRANSACTION;
                RETURN;
            END;

            INSERT INTO Reservas (ID_Clase, ID_Alumno, Fecha_Reserva, Asistio)
            VALUES (@ID_Clase, @ID_Alumno, GETDATE(), NULL);
            -- trg_Reservas_DescontarClase descuenta la clase automaticamente
        COMMIT TRANSACTION;
        PRINT 'Reserva registrada con exito';
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        PRINT 'Error al registrar la reserva: ' + ERROR_MESSAGE();
    END CATCH;
END;
GO

/* ============================================================================
   07 - CONSULTAS (10 -> consigna 17.d.i: JOINs, subconsultas y agregados)
   Regla del grupo: columnas explicitas, sin SELECT *
============================================================================ */

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


--6)
--Ingresos totales por metodo de pago
--sumar cuanto se recaudo con cada metodo de pago y cuantos pagos hubo

SELECT
    mp.Nombre_Metodo,
    COUNT(*) AS Cantidad_Pagos,
    --SUM agrega todos los montos del mismo metodo
    SUM(p.Monto_Pago) AS Total_Recaudado
FROM Pagos AS p
JOIN Metodos_Pago AS mp
    ON mp.ID_Metodo_Pago = p.ID_Metodo_Pago
GROUP BY
    mp.Nombre_Metodo
--Ordeno de mayor a menor recaudacion
ORDER BY Total_Recaudado DESC;


--7)
--Profesores y cantidad de clases que dictan
--listar todos los profesores con cuantas clases tienen asignadas
--(incluso los que no dictan ninguna)

SELECT
    pr.ID_Profesor,
    pr.Nombre_Profesor,
    pr.Apellido_Profesor,
    --LEFT JOIN: si el profesor no dicta clases, igual aparece con 0
    COUNT(c.ID_Clase) AS Cantidad_Clases
FROM Profesores AS pr
LEFT JOIN Clases AS c
    ON c.ID_Profesor = pr.ID_Profesor
GROUP BY
    pr.ID_Profesor,
    pr.Nombre_Profesor,
    pr.Apellido_Profesor
ORDER BY Cantidad_Clases DESC;


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


--9)
--Alumnos activos sin reservas a futuro
--detectar alumnos activos que no tienen ninguna clase reservada de aca en adelante

SELECT
    a.ID_Alumno,
    a.Nombre_Alumno,
    a.Apellido_Alumno
FROM Alumnos AS a
WHERE a.Estado_Alumno = 'Activo'
    --Subconsulta correlacionada: traigo solo los alumnos que NO tienen
    --una reserva activa en una clase con fecha futura
    AND NOT EXISTS (
        SELECT 1
        FROM Reservas AS r
        JOIN Clases AS c
            ON c.ID_Clase = r.ID_Clase
        WHERE r.ID_Alumno = a.ID_Alumno
            AND r.Fecha_Cancelacion IS NULL
            AND c.Fecha_Clase > CAST(GETDATE() AS DATE)
    );


--10)
--Detalle completo de reservas
--mostrar cada reserva con alumno, clase, sede, profesor y el estado segun corresponda

SELECT
    r.ID_Reserva,
    a.Nombre_Alumno + ' ' + a.Apellido_Alumno AS Alumno,
    c.Nombre_Clase,
    c.Fecha_Clase,
    sede.Nombre_Sede,
    pr.Apellido_Profesor AS Profesor,
    --CASE: traduzco las columnas de la reserva a un estado legible
    CASE
        WHEN r.Fecha_Cancelacion IS NOT NULL THEN 'Cancelada'
        WHEN r.Asistio = 1 THEN 'Asistio'
        WHEN r.Asistio = 0 THEN 'Ausente'
        ELSE 'Pendiente'
    END AS Estado_Reserva
FROM Reservas AS r
JOIN Alumnos AS a
    ON a.ID_Alumno = r.ID_Alumno
JOIN Clases AS c
    ON c.ID_Clase = r.ID_Clase
JOIN Salones AS s
    ON s.ID_Salon = c.ID_Salon
JOIN Sedes AS sede
    ON sede.ID_Sede = s.ID_Sede
JOIN Profesores AS pr
    ON pr.ID_Profesor = c.ID_Profesor
ORDER BY c.Fecha_Clase;

GO
