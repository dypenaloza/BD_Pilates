CREATE TABLE Alumnos (
--Atributos
ID_Alumno INT Identity(100,1) NOT NULL,
Nombre_Alumno VARCHAR(25) NOT NULL,
Apellido_Alumno VARCHAR(25) NOT NULL,
DNI_Alumno VARCHAR(10) NOT NULL,
Telefono_Alumno VARCHAR(20) NOT NULL,
Email_Alumno VARCHAR(50) NOT NULL,
Fecha_Nacimiento DATE NOT NULL,
Estado_Alumno VARCHAR(15) NOT NULL,

--Constraints

--Que ID_Alumnos sea PK
CONSTRAINT PK_Alumnos PRIMARY KEY (ID_Alumno),
--ck: check, Constraint para que estado solo sea Activo o Inactivo
CONSTRAINT CK_Alumnos_Estado CHECK (Estado_Alumno IN ('Activo','Inactivo')),
--UQ: unique, verificar que el DNI de alumnos no se repita
CONSTRAINT UQ_Alumnos_DNI UNIQUE (DNI_Alumno),
--DNI más de 8 dígitos (es un varchar)
CONSTRAINT CK_Dni_Alumno CHECK (len(DNI_Alumno) >= 8),
--Fecha nacimiento mayor a 1930
CONSTRAINT CK_FechaNacimiento CHECK (Fecha_Nacimiento > '1930-01-01')
);
go

CREATE TABLE Profesores (
--Atributos
ID_Profesor INT IDENTITY(100,1) NOT NULL,
Nombre_Profesor VARCHAR(25) NOT NULL,
Apellido_Profesor VARCHAR(25) NOT NULL,
Telefono_Profesor VARCHAR(25) NOT NULL,
Email_Profesor VARCHAR(50) NOT NULL,
Especialidad VARCHAR(25) NOT NULL,
Estado_Profesor VARCHAR(15) NOT NULL,

--Constraints
CONSTRAINT PK_Profesores PRIMARY KEY (ID_Profesor),
--Mail y teléfono únicos
CONSTRAINT UQ_Profesores_Email UNIQUE (Email_Profesor),
CONSTRAINT UQ_Profesores_Telefono UNIQUE (Telefono_Profesor),
--Estado solo "Activo" o "Inactivo"
CONSTRAINT CK_Profesores_Estado CHECK (Estado_Profesor IN ('Activo','Inactivo') )
);


CREATE TABLE Planes (
--Atributos
ID_Plan INT IDENTITY(1,1) NOT NULL,
Nombre_Plan VARCHAR(50) NOT NULL,
Cantidad_Clases INT NOT NULL,
Precio_Plan DECIMAL(10,2) NOT NULL,
Duracion_Dias INT NOT NULL,

--Constraints
CONSTRAINT PK_Planes PRIMARY KEY (ID_Plan),
--Validamos que el nombre del plan sea único
CONSTRAINT UQ_Planes_NombrePlan UNIQUE (Nombre_Plan),
--Validamos que todos sean mayor a 0
CONSTRAINT CK_Planes_CantidadClases CHECK (Cantidad_Clases > 0),
CONSTRAINT CK_Planes_PrecioPlan CHECK (Precio_Plan > 0),
CONSTRAINT CK_Planes_DuracionDias CHECK (Duracion_Dias > 0)
);

go

CREATE TABLE Sedes (
--Atributos
ID_Sede INT IDENTITY(100,1) NOT NULL,
Nombre_Sede VARCHAR(25) NOT NULL,
Direccion_Sede VARCHAR(100) NOT NULL,
Telefono_Sede VARCHAR(25) NOT NULL,

--Constraints
CONSTRAINT PK_Sedes PRIMARY KEY (ID_Sede),
--Evitar que nombre y dirección sean iguales,se puede repetir nombre
--pero no nombre y dirección
CONSTRAINT UQ_Sedes_NombreDireccion UNIQUE (Nombre_Sede, Direccion_Sede)
);

CREATE TABLE Salones (
--Atributos
ID_Salon INT IDENTITY(1,1) NOT NULL,
ID_Sede INT NOT NULL,
Nombre_Salon VARCHAR(25) NOT NULL,
Cantidad_Reformers INT NOT NULL,

--Constraints
CONSTRAINT PK_Salones PRIMARY KEY (ID_Salon),
--Foreign key de sedes
CONSTRAINT FK_Salones_Sedes FOREIGN KEY (ID_Sede) REFERENCES Sedes(ID_Sede),
--Se evita repetir el mismo salón dentro de la misma sede,
--pero se pueden nombres iguales en sedes distintas
CONSTRAINT UQ_Salones_NombreSalon UNIQUE (ID_Sede, Nombre_Salon),
CONSTRAINT CK_Salones_CantReformers CHECK (Cantidad_Reformers > 0)
);

CREATE TABLE Clases (
--Atributos
ID_Clase INT IDENTITY (1000,1) NOT NULL,
ID_Salon INT NOT NULL,
ID_Profesor INT NOT NULL,
Nombre_Clase VARCHAR(25) NOT NULL,
Fecha_Clase DATE NOT NULL,
Hora_Inicio TIME NOT NULL,
Hora_Fin TIME NOT NULL,

--Constraints
CONSTRAINT PK_Clases PRIMARY KEY (ID_Clase),
--FK
CONSTRAINT FK_Clases_Salon FOREIGN KEY (ID_Salon) REFERENCES Salones(ID_Salon),
CONSTRAINT FK_Clases_Profesor FOREIGN KEY (ID_Profesor) REFERENCES Profesores(ID_Profesor),
--Validar hora inicio antes que hora fin
CONSTRAINT CK_Clases_HoraInicioFin CHECK (Hora_Inicio < Hora_Fin),
--Validar que no haya dos reservar en el mismo salón con la misma hora y la misma fecha
CONSTRAINT UQ_Clases_SalonFechaHora UNIQUE (ID_Salon, Fecha_Clase, Hora_Inicio),
--Evitar que un profe tenga dos clases al mismo tiempo
CONSTRAINT UQ_Clases_ProfesorSalonHora UNIQUE (ID_Profesor, Fecha_Clase, Hora_Inicio)
);

CREATE TABLE Motivo_Cancelacion (
--Atributos
ID_Motivo_Cancelacion INT IDENTITY(1,1) NOT NULL,
Desc_Motivo VARCHAR(100) NOT NULL,

--Constraints
--PK
CONSTRAINT PK_Motivo_Cancelacion PRIMARY KEY (ID_Motivo_Cancelacion),
--Que los motivos de cancelación no se repitan:
CONSTRAINT UQ_MotivoCancelacion_DescMotivo UNIQUE (Desc_Motivo)
);


CREATE TABLE Reservas (
--Atributos
ID_Reserva INT IDENTITY(1000,1) NOT NULL,
ID_Clase INT NOT NULL,
ID_Alumno INT NOT NULL,
ID_Motivo_Cancelacion INT NULL,
Fecha_Reserva DATETIME NOT NULL,
Asistio BIT NULL, --Puede ser null ya que antes de tomar lista no se sabe si asistió
Observacion_Asistencia VARCHAR(100) NULL,
Fecha_Cancelacion DATETIME NULL,
Recupera_Clase BIT NULL, --Puede ser null ya que antes de tomar lista no se sabe si asistió

--Constraints
CONSTRAINT PK_Reservas PRIMARY KEY (ID_Reserva),
--FK
CONSTRAINT FK_Reservas_Clase FOREIGN KEY (ID_Clase) REFERENCES Clases(ID_Clase),
CONSTRAINT FK_Reservas_Alumno FOREIGN KEY (ID_Alumno) REFERENCES Alumnos(ID_Alumno),
CONSTRAINT FK_Reservas_MotivoCancelacion FOREIGN KEY (ID_Motivo_Cancelacion) REFERENCES Motivo_Cancelacion(ID_Motivo_Cancelacion),
--Verificar que fecha cancelación sea después de fecha reserva (o null)
CONSTRAINT CK_Reservas_FechaReservaCancelacion CHECK (Fecha_Cancelacion IS NULL OR Fecha_Reserva <= Fecha_Cancelacion),
--Si hay cancelación, debe haber motivo. Si no hay, el motivo debe ser null
CONSTRAINT CK_Reservas_CancelacionCompleta CHECK
(
	(Fecha_Cancelacion IS NULL AND ID_Motivo_Cancelacion IS NULL)
	OR
	(Fecha_Cancelacion IS NOT NULL AND ID_Motivo_Cancelacion IS NOT NULL)
),
--Si hay cancelación, no puede haber asistencia. Si hay asistencia, no puede haber cancelación
CONSTRAINT CK_Reservas_CancelacionAsistencia CHECK
(Fecha_Cancelacion IS NULL OR Asistio IS NULL),
--Un alumno no puede reservar dos veces la misma clase
CONSTRAINT UQ_Reservas_AlumnoClase UNIQUE (ID_Alumno,ID_Clase)
);

--Correción posterior:
ALTER TABLE Reservas
ADD CONSTRAINT CK_Reservas_RecuperaClase_Logica
CHECK (
--Caso 1: Canceló entonces no puede asistir (null), y recupera clase no debe quedar vacío
    (Fecha_Cancelacion IS NOT NULL AND Asistio IS NULL AND Recupera_Clase IS NOT NULL)
    OR
--Caso 2: No canceló, pero aun no se tomó lista asi que puede quedar null
    (Fecha_Cancelacion IS NULL  AND Asistio IS NULL AND Recupera_Clase IS NULL)
    OR
--Caso 3: no canceló y ya se registró asistencia
    (Fecha_Cancelacion IS NULL AND Asistio IS NOT NULL AND Recupera_Clase = 0)
);

CREATE TABLE Lista_de_Espera (
--Atributos
ID_Lista_Espera INT IDENTITY(1000,1) NOT NULL,
ID_Alumno INT NOT NULL,
ID_Clase INT NOT NULL,
Fecha_Solicitud DATETIME NOT NULL,
Estado_Lista_Espera VARCHAR(15) NOT NULL,

--Constraints
CONSTRAINT PK_ListaEspera PRIMARY KEY (ID_Lista_Espera),
--FK
CONSTRAINT FK_ListaEspera_Alumno FOREIGN KEY (ID_Alumno) REFERENCES Alumnos(ID_Alumno),
CONSTRAINT FK_ListaEspera_Clase FOREIGN KEY (ID_Clase) REFERENCES Clases(ID_Clase),

--Un alumno no puede anotarse dos veces a la lista de espera de la misma clase
CONSTRAINT UQ_ListaEspera_AlumnoClase UNIQUE (ID_Alumno,ID_Clase),
--Estado solo puede ser reservado o esperando
CONSTRAINT CK_ListaEspera_Estado CHECK (Estado_Lista_Espera in ('Reservado','Esperando') )
);

CREATE TABLE Matriculas (
--Atributos
ID_Matricula INT IDENTITY(1000,1) NOT NULL,
ID_Plan INT NOT NULL,
ID_Alumno INT NOT NULL,
Fecha_Inicio DATE NOT NULL,
Clases_Disponibles INT NOT NULL,
Estado_Matricula VARCHAR(15) NOT NULL,

--Constraints
--PK
CONSTRAINT PK_Matriculas PRIMARY KEY (ID_Matricula),
--FK
CONSTRAINT FK_Matriculas_Planes FOREIGN KEY (ID_Plan) REFERENCES Planes(ID_Plan),
CONSTRAINT FK_Matriculas_Alumnos FOREIGN KEY (ID_Alumno) REFERENCES Alumnos(ID_Alumno),
--Clase disponibles mayor o igual a 0
CONSTRAINT CK_Matriculas_ClasesDisp CHECK (Clases_Disponibles >= 0),
--Estado solo puede ser activo o inactivo
CONSTRAINT CK_Matriculas_Estado CHECK (Estado_Matricula IN ('Activa','Inactiva') )
);

CREATE TABLE Metodos_Pago (
--Atributos
ID_Metodo_Pago INT IDENTITY(1,1) NOT NULL,
Nombre_Metodo VARCHAR(50) NOT NULL,

--PK
CONSTRAINT PK_MetodosPago PRIMARY KEY (ID_Metodo_Pago),
--Verificar que el nombre no se repita
CONSTRAINT UQ_MetodosPago_Nombre UNIQUE (Nombre_Metodo)
);

CREATE TABLE Pagos (
--Atributos
ID_Pago INT IDENTITY(1000,1) NOT NULL,
ID_Matricula INT NOT NULL,
ID_Metodo_Pago INT NOT NULL,
Fecha_Pago DATE NOT NULL,
Monto_Pago DECIMAL(10,2) NOT NULL,

--Constraints
--PK
CONSTRAINT PK_Pagos PRIMARY KEY (ID_Pago),
--FK
CONSTRAINT FK_Pagos_Matriculas FOREIGN KEY (ID_Matricula) REFERENCES Matriculas(ID_Matricula),
CONSTRAINT FK_Pagos_Metodo FOREIGN KEY (ID_Metodo_Pago) REFERENCES Metodos_Pago(ID_Metodo_Pago)
);


--CONSULTAS

--Alumnos activos con su plan vigente
