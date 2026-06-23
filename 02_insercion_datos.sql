
--Sedes

INSERT INTO Sedes (Nombre_Sede, Direccion_Sede, Telefono_Sede) 
VALUES ('Sede Centro', 'Av. Corrientes 1234', '1145556001');

INSERT INTO Sedes (Nombre_Sede, Direccion_Sede, Telefono_Sede) 
VALUES ('Sede Palermo', 'Av. Santa Fe 4500', '1145556002');

INSERT INTO Sedes (Nombre_Sede, Direccion_Sede, Telefono_Sede) 
VALUES ('Sede Belgrano', 'Av. Cabildo 2100', '1145556003');


-- Salone s (ID_Sede: 100=Centro, 101=Palermo, 102=Belgrano)

INSERT INTO Salones (ID_Sede, Nombre_Salon, Cantidad_Reformers) 
VALUES (100, 'Salón A', 8);

INSERT INTO Salones (ID_Sede, Nombre_Salon, Cantidad_Reformers) 
VALUES (100, 'Salón B', 6);

INSERT INTO Salones (ID_Sede, Nombre_Salon, Cantidad_Reformers) 
VALUES (101, 'Salón A', 10);

INSERT INTO Salones (ID_Sede, Nombre_Salon, Cantidad_Reformers) 
VALUES (101, 'Salón B', 8);

INSERT INTO Salones (ID_Sede, Nombre_Salon, Cantidad_Reformers) 
VALUES (102, 'Salón Único', 6);


--Profes

INSERT INTO Profesores (Nombre_Profesor, Apellido_Profesor, Telefono_Profesor, Email_Profesor, Especialidad, Estado_Profesor)
VALUES ('Carla', 'Gómez', '1156667001', 'carla.gomez@bdpilates.com', 'Pilates Mat', 'Activo');

INSERT INTO Profesores (Nombre_Profesor, Apellido_Profesor, Telefono_Profesor, Email_Profesor, Especialidad, Estado_Profesor)
VALUES ('Martín', 'Pérez', '1156667002', 'martin.perez@bdpilates.com', 'Pilates Reformer', 'Activo');

INSERT INTO Profesores (Nombre_Profesor, Apellido_Profesor, Telefono_Profesor, Email_Profesor, Especialidad, Estado_Profesor)
VALUES ('Lucía', 'Fernández', '1156667003', 'lucia.fernandez@bdpilates.com', 'Pilates Terapéutico', 'Activo');

INSERT INTO Profesores (Nombre_Profesor, Apellido_Profesor, Telefono_Profesor, Email_Profesor, Especialidad, Estado_Profesor)
VALUES ('Diego', 'Sosa', '1156667004', 'diego.sosa@bdpilates.com', 'Pilates Reformer', 'Inactivo');

INSERT INTO Profesores (Nombre_Profesor, Apellido_Profesor, Telefono_Profesor, Email_Profesor, Especialidad, Estado_Profesor)
VALUES ('Paula', 'Giménez', '1156667005', 'paula.gimenez@bdpilates.com', 'Pilates Mat', 'Activo');

INSERT INTO Profesores (Nombre_Profesor, Apellido_Profesor, Telefono_Profesor, Email_Profesor, Especialidad, Estado_Profesor)
VALUES ('Andrés', 'Molina', '1156667006', 'andres.molina@bdpilates.com', 'Pilates Reformer', 'Activo');

INSERT INTO Profesores (Nombre_Profesor, Apellido_Profesor, Telefono_Profesor, Email_Profesor, Especialidad, Estado_Profesor)
VALUES ('Florencia', 'Castro', '1156667007', 'florencia.castro@bdpilates.com', 'Pilates Terapéutico', 'Activo');

INSERT INTO Profesores (Nombre_Profesor, Apellido_Profesor, Telefono_Profesor, Email_Profesor, Especialidad, Estado_Profesor)
VALUES ('Gabriel', 'Ruiz', '1156667008', 'gabriel.ruiz@bdpilates.com', 'Pilates Mat', 'Activo');

INSERT INTO Profesores (Nombre_Profesor, Apellido_Profesor, Telefono_Profesor, Email_Profesor, Especialidad, Estado_Profesor)
VALUES ('Marina', 'Vega', '1156667009', 'marina.vega@bdpilates.com', 'Pilates Reformer', 'Inactivo');

INSERT INTO Profesores (Nombre_Profesor, Apellido_Profesor, Telefono_Profesor, Email_Profesor, Especialidad, Estado_Profesor)
VALUES ('Hernán', 'Díaz', '1156667010', 'hernan.diaz@bdpilates.com', 'Pilates Mat', 'Activo');

--
-- PLANES
--
INSERT INTO Planes (Nombre_Plan, Cantidad_Clases, Precio_Plan, Duracion_Dias) 
VALUES ('Plan 8 clases', 8, 12000.00, 30);

INSERT INTO Planes (Nombre_Plan, Cantidad_Clases, Precio_Plan, Duracion_Dias) 
VALUES ('Plan 12 clases', 12, 16000.00, 30);

INSERT INTO Planes (Nombre_Plan, Cantidad_Clases, Precio_Plan, Duracion_Dias) 
VALUES ('Plan Ilimitado', 30, 22000.00, 30);

INSERT INTO Planes (Nombre_Plan, Cantidad_Clases, Precio_Plan, Duracion_Dias) 
VALUES ('Plan Trimestral 24 clases', 24, 40000.00, 90);


--Alumnos 

INSERT INTO Alumnos (Nombre_Alumno, Apellido_Alumno, DNI_Alumno, Telefono_Alumno, Email_Alumno, Fecha_Nacimiento, Estado_Alumno)
VALUES ('Sofía', 'Ramírez', '30111222', '1167778001', 'sofia.ramirez@mail.com', '1992-03-14', 'Activo');

INSERT INTO Alumnos (Nombre_Alumno, Apellido_Alumno, DNI_Alumno, Telefono_Alumno, Email_Alumno, Fecha_Nacimiento, Estado_Alumno)
VALUES ('Juan', 'Torres', '28222333', '1167778002', 'juan.torres@mail.com', '1988-07-22', 'Activo');

INSERT INTO Alumnos (Nombre_Alumno, Apellido_Alumno, DNI_Alumno, Telefono_Alumno, Email_Alumno, Fecha_Nacimiento, Estado_Alumno)
VALUES ('Valentina', 'Díaz', '35333444', '1167778003', 'valentina.diaz@mail.com', '1995-11-02', 'Activo');

INSERT INTO Alumnos (Nombre_Alumno, Apellido_Alumno, DNI_Alumno, Telefono_Alumno, Email_Alumno, Fecha_Nacimiento, Estado_Alumno)
VALUES ('Mateo', 'López', '32444555', '1167778004', 'mateo.lopez@mail.com', '1990-01-30', 'Activo');

INSERT INTO Alumnos (Nombre_Alumno, Apellido_Alumno, DNI_Alumno, Telefono_Alumno, Email_Alumno, Fecha_Nacimiento, Estado_Alumno)
VALUES ('Camila', 'Suárez', '31555666', '1167778005', 'camila.suarez@mail.com', '1993-05-18', 'Activo');

INSERT INTO Alumnos (Nombre_Alumno, Apellido_Alumno, DNI_Alumno, Telefono_Alumno, Email_Alumno, Fecha_Nacimiento, Estado_Alumno)
VALUES ('Tomás', 'Acosta', '29666777', '1167778006', 'tomas.acosta@mail.com', '1991-09-09', 'Inactivo');

INSERT INTO Alumnos (Nombre_Alumno, Apellido_Alumno, DNI_Alumno, Telefono_Alumno, Email_Alumno, Fecha_Nacimiento, Estado_Alumno)
VALUES ('Lucía', 'Romero', '33777888', '1167778007', 'lucia.romero@mail.com', '1996-12-25', 'Activo');

INSERT INTO Alumnos (Nombre_Alumno, Apellido_Alumno, DNI_Alumno, Telefono_Alumno, Email_Alumno, Fecha_Nacimiento, Estado_Alumno)
VALUES ('Nicolás', 'Herrera', '34888999', '1167778008', 'nicolas.herrera@mail.com', '1994-04-04', 'Activo');

INSERT INTO Alumnos (Nombre_Alumno, Apellido_Alumno, DNI_Alumno, Telefono_Alumno, Email_Alumno, Fecha_Nacimiento, Estado_Alumno)
VALUES ('Brenda', 'Molina', '36888111', '1167778009', 'brenda.molina@mail.com', '1998-02-10', 'Activo');

INSERT INTO Alumnos (Nombre_Alumno, Apellido_Alumno, DNI_Alumno, Telefono_Alumno, Email_Alumno, Fecha_Nacimiento, Estado_Alumno)
VALUES ('Federico', 'Ríos', '37999222', '1167778010', 'federico.rios@mail.com', '1999-08-21', 'Activo');



-- CLASES (Principal)
-- (ID_Salon: 1=CentroA, 2=CentroB, 3=PalermoA, 4=PalermoB, 5=Belgrano)
-- (ID_Profesor: 100=Carla, 101=Martín, 102=Lucía, 103=Diego)
-- Las primeras 4 ya pasaron (para tener asistencia/cancelación cargada).
-- Las últimas 6 son a futuro.

INSERT INTO Clases (ID_Salon, ID_Profesor, Nombre_Clase, Fecha_Clase, Hora_Inicio, Hora_Fin) 
VALUES (1, 100, 'Pilates Mat', '2026-06-10', '08:00', '09:00');         

INSERT INTO Clases (ID_Salon, ID_Profesor, Nombre_Clase, Fecha_Clase, Hora_Inicio, Hora_Fin) 
VALUES (2, 101, 'Pilates Reformer', '2026-06-12', '09:00', '10:00');     
INSERT INTO Clases (ID_Salon, ID_Profesor, Nombre_Clase, Fecha_Clase, Hora_Inicio, Hora_Fin) 
VALUES (3, 102, 'Pilates Terapéutico', '2026-06-15', '10:00', '11:00');  

INSERT INTO Clases (ID_Salon, ID_Profesor, Nombre_Clase, Fecha_Clase, Hora_Inicio, Hora_Fin) 
VALUES (5, 103, 'Pilates Reformer', '2026-06-17', '19:00', '20:00');     

INSERT INTO Clases (ID_Salon, ID_Profesor, Nombre_Clase, Fecha_Clase, Hora_Inicio, Hora_Fin) 
VALUES (1, 100, 'Pilates Mat', '2026-06-22', '08:00', '09:00');         

INSERT INTO Clases (ID_Salon, ID_Profesor, Nombre_Clase, Fecha_Clase, Hora_Inicio, Hora_Fin) 
VALUES (2, 101, 'Pilates Reformer', '2026-06-23', '09:00', '10:00');     

INSERT INTO Clases (ID_Salon, ID_Profesor, Nombre_Clase, Fecha_Clase, Hora_Inicio, Hora_Fin) 
VALUES (3, 102, 'Pilates Terapéutico', '2026-06-24', '10:00', '11:00');  

INSERT INTO Clases (ID_Salon, ID_Profesor, Nombre_Clase, Fecha_Clase, Hora_Inicio, Hora_Fin) 
VALUES (4, 101, 'Pilates Reformer', '2026-06-25', '18:00', '19:00');     

INSERT INTO Clases (ID_Salon, ID_Profesor, Nombre_Clase, Fecha_Clase, Hora_Inicio, Hora_Fin) 
VALUES (5, 102, 'Pilates Terapéutico', '2026-06-26', '19:00', '20:00');  

INSERT INTO Clases (ID_Salon, ID_Profesor, Nombre_Clase, Fecha_Clase, Hora_Inicio, Hora_Fin) 
VALUES (2, 100, 'Pilates Mat', '2026-06-27', '18:00', '19:00');         


-- Motivo cancelacion

INSERT INTO Motivo_Cancelacion (Desc_Motivo) 
VALUES ('Enfermedad');

INSERT INTO Motivo_Cancelacion (Desc_Motivo) 
VALUES ('Motivos laborales');

INSERT INTO Motivo_Cancelacion (Desc_Motivo) 
VALUES ('Viaje');

INSERT INTO Motivo_Cancelacion (Desc_Motivo) 
VALUES ('Falta de tiempo');


-- Matriculas(ID_Plan: 1=Plan8, 2=Plan12, 3=Ilimitado, 4=Trimestral)


INSERT INTO Matriculas (ID_Plan, ID_Alumno, Fecha_Inicio, Clases_Disponibles, Estado_Matricula) VALUES (2, 100, '2026-06-01', 9, 'Activa');   -- Sofia
INSERT INTO Matriculas (ID_Plan, ID_Alumno, Fecha_Inicio, Clases_Disponibles, Estado_Matricula) VALUES (3, 101, '2026-06-01', 25, 'Activa');  -- Juan
INSERT INTO Matriculas (ID_Plan, ID_Alumno, Fecha_Inicio, Clases_Disponibles, Estado_Matricula) VALUES (1, 102, '2026-06-05', 5, 'Activa');   --Valentina
INSERT INTO Matriculas (ID_Plan, ID_Alumno, Fecha_Inicio, Clases_Disponibles, Estado_Matricula) VALUES (4, 103, '2026-05-15', 18, 'Activa');  -- Mateo
INSERT INTO Matriculas (ID_Plan, ID_Alumno, Fecha_Inicio, Clases_Disponibles, Estado_Matricula) VALUES (2, 104, '2026-06-10', 12, 'Activa');  --Camila
INSERT INTO Matriculas (ID_Plan, ID_Alumno, Fecha_Inicio, Clases_Disponibles, Estado_Matricula) VALUES (1, 105, '2026-05-01', 2, 'Inactiva');  -- Tomás
INSERT INTO Matriculas (ID_Plan, ID_Alumno, Fecha_Inicio, Clases_Disponibles, Estado_Matricula) VALUES (3, 106, '2026-06-01', 28, 'Activa');  --Lucía
INSERT INTO Matriculas (ID_Plan, ID_Alumno, Fecha_Inicio, Clases_Disponibles, Estado_Matricula) VALUES (1, 107, '2026-06-15', 8, 'Activa');   -- Nicolás
INSERT INTO Matriculas (ID_Plan, ID_Alumno, Fecha_Inicio, Clases_Disponibles, Estado_Matricula) VALUES (1, 108, '2026-06-12', 8, 'Activa');   -- Brenda
INSERT INTO Matriculas (ID_Plan, ID_Alumno, Fecha_Inicio, Clases_Disponibles, Estado_Matricula) VALUES (2, 109, '2026-06-14', 12, 'Activa');  -- Federico


-- metodo pago

INSERT INTO Metodos_Pago (Nombre_Metodo) 
VALUES ('Efectivo');
INSERT INTO Metodos_Pago (Nombre_Metodo) 
VALUES ('Tarjeta de Débito');
INSERT INTO Metodos_Pago (Nombre_Metodo) 
VALUES ('Tarjeta de Crédito');
INSERT INTO Metodos_Pago (Nombre_Metodo) 
VALUES ('Transferencia');


-- Pagos (uno por matrícula -> trazabilidad Alumno-Matrícula-Pago)
-- (ID_Metodo_Pago: 1=Efectivo, 2=Débito, 3=Crédito, 4=Transferencia)

INSERT INTO Pagos (ID_Matricula, ID_Metodo_Pago, Fecha_Pago, Monto_Pago) VALUES (1000, 3, '2026-06-01', 16000.00);  -- Sofía
INSERT INTO Pagos (ID_Matricula, ID_Metodo_Pago, Fecha_Pago, Monto_Pago) VALUES (1001, 4, '2026-06-01', 22000.00);  -- Juan
INSERT INTO Pagos (ID_Matricula, ID_Metodo_Pago, Fecha_Pago, Monto_Pago) VALUES (1002, 1, '2026-06-05', 12000.00);  -- Valentina
INSERT INTO Pagos (ID_Matricula, ID_Metodo_Pago, Fecha_Pago, Monto_Pago) VALUES (1003, 2, '2026-05-15', 40000.00);  -- Mateo
INSERT INTO Pagos (ID_Matricula, ID_Metodo_Pago, Fecha_Pago, Monto_Pago) VALUES (1004, 3, '2026-06-10', 16000.00);  -- Camila
INSERT INTO Pagos (ID_Matricula, ID_Metodo_Pago, Fecha_Pago, Monto_Pago) VALUES (1005, 1, '2026-05-01', 12000.00);  -- Tomás
INSERT INTO Pagos (ID_Matricula, ID_Metodo_Pago, Fecha_Pago, Monto_Pago) VALUES (1006, 4, '2026-06-01', 22000.00);  -- Lucía
INSERT INTO Pagos (ID_Matricula, ID_Metodo_Pago, Fecha_Pago, Monto_Pago) VALUES (1007, 2, '2026-06-15', 12000.00);  -- Nicolás
INSERT INTO Pagos (ID_Matricula, ID_Metodo_Pago, Fecha_Pago, Monto_Pago) VALUES (1008, 2, '2026-06-12', 12000.00);  -- Brenda
INSERT INTO Pagos (ID_Matricula, ID_Metodo_Pago, Fecha_Pago, Monto_Pago) VALUES (1009, 4, '2026-06-14', 16000.00);  -- Federico


-- RESERVAS
-- (ID_Clase: 1000 a 1003 ya pasaron, 1004 a 1009 son a futuro)
-- Tomás (105) falta a 3 clases seguidas -> por eso su Estado_Alumno es inactivo


-- Clase 1000
INSERT INTO Reservas (ID_Clase, ID_Alumno, Fecha_Reserva, Asistio, Observacion_Asistencia, Recupera_Clase) VALUES (1000, 100, '2026-06-08 10:00', 1, NULL, 0);              -- Sofía asiste
INSERT INTO Reservas (ID_Clase, ID_Alumno, Fecha_Reserva, Asistio, Observacion_Asistencia, Recupera_Clase) VALUES (1000, 105, '2026-06-08 11:00', 0, 'No se presentó', 0);  -- Tomás falta

-- Clase 1001
INSERT INTO Reservas (ID_Clase, ID_Alumno, Fecha_Reserva, Asistio, Observacion_Asistencia, Recupera_Clase) VALUES (1001, 102, '2026-06-10 09:00', 1, NULL, 0);              -- Valentina asiste
INSERT INTO Reservas (ID_Clase, ID_Alumno, Fecha_Reserva, Asistio, Observacion_Asistencia, Recupera_Clase) VALUES (1001, 105, '2026-06-10 09:30', 0, 'No se presentó', 0);  -- Tomás falta

-- Clase 1002 
INSERT INTO Reservas (ID_Clase, ID_Alumno, Fecha_Reserva, Asistio, Observacion_Asistencia, Recupera_Clase) VALUES (1002, 104, '2026-06-13 12:00', 1, NULL, 0);              -- Camila asiste
INSERT INTO Reservas (ID_Clase, ID_Alumno, Fecha_Reserva, Asistio, Observacion_Asistencia, Recupera_Clase) VALUES (1002, 105, '2026-06-13 12:30', 0, 'No se presentó', 0);  -- Tomás falta

-- Clase 1003 
INSERT INTO Reservas (ID_Clase, ID_Alumno, Fecha_Reserva, Asistio, Observacion_Asistencia, Recupera_Clase) VALUES (1003, 107, '2026-06-15 08:00', 1, NULL , 0);
INSERT INTO Reservas (ID_Clase, ID_Alumno, Fecha_Reserva, Asistio, ID_Motivo_Cancelacion, Fecha_Cancelacion, Recupera_Clase) VALUES (1003, 106, '2026-06-14 09:00', NULL, 2, '2026-06-16 14:00', 1); --Lucia canceló, puede recuperar

-- Clases a futuro (todavía no se tomó lista, por eso Asistio = NULL)
INSERT INTO Reservas (ID_Clase, ID_Alumno, Fecha_Reserva, Asistio) VALUES (1004, 100, '2026-06-19 09:00', NULL);  -- Sofía
INSERT INTO Reservas (ID_Clase, ID_Alumno, Fecha_Reserva, Asistio) VALUES (1004, 101, '2026-06-19 09:10', NULL);  -- Juan
INSERT INTO Reservas (ID_Clase, ID_Alumno, Fecha_Reserva, Asistio) VALUES (1005, 102, '2026-06-19 09:20', NULL);  -- Valentina
INSERT INTO Reservas (ID_Clase, ID_Alumno, Fecha_Reserva, Asistio) VALUES (1005, 103, '2026-06-19 09:30', NULL);  -- Mateo
INSERT INTO Reservas (ID_Clase, ID_Alumno, Fecha_Reserva, Asistio) VALUES (1006, 104, '2026-06-19 09:40', NULL);  -- Camila
INSERT INTO Reservas (ID_Clase, ID_Alumno, Fecha_Reserva, Asistio) VALUES (1006, 107, '2026-06-19 09:50', NULL);  -- Nicolás
INSERT INTO Reservas (ID_Clase, ID_Alumno, Fecha_Reserva, Asistio) VALUES (1007, 100, '2026-06-19 10:00', NULL);  -- Sofía
INSERT INTO Reservas (ID_Clase, ID_Alumno, Fecha_Reserva, Asistio) VALUES (1008, 103, '2026-06-19 10:10', NULL);  -- Mateo
INSERT INTO Reservas (ID_Clase, ID_Alumno, Fecha_Reserva, Asistio) VALUES (1009, 101, '2026-06-19 10:20', NULL);  -- Juan


-- Listas de espera 

INSERT INTO Lista_de_Espera (ID_Alumno, ID_Clase, Fecha_Solicitud, Estado_Lista_Espera) VALUES (106, 1005, '2026-06-18', 'Esperando');  -- Lucía
INSERT INTO Lista_de_Espera (ID_Alumno, ID_Clase, Fecha_Solicitud, Estado_Lista_Espera) VALUES (100, 1006, '2026-06-19', 'Esperando');  -- Sofía
INSERT INTO Lista_de_Espera (ID_Alumno, ID_Clase, Fecha_Solicitud, Estado_Lista_Espera) VALUES (102, 1009, '2026-06-19', 'Esperando');  -- Valentina
INSERT INTO Lista_de_Espera (ID_Alumno, ID_Clase, Fecha_Solicitud, Estado_Lista_Espera) VALUES (101, 1006, '2026-06-19', 'Esperando');  -- Juan
INSERT INTO Lista_de_Espera (ID_Alumno, ID_Clase, Fecha_Solicitud, Estado_Lista_Espera) VALUES (103, 1009, '2026-06-19', 'Esperando');  -- Mateo
INSERT INTO Lista_de_Espera (ID_Alumno, ID_Clase, Fecha_Solicitud, Estado_Lista_Espera) VALUES (108, 1005, '2026-06-19', 'Esperando');  -- Brenda
INSERT INTO Lista_de_Espera (ID_Alumno, ID_Clase, Fecha_Solicitud, Estado_Lista_Espera) VALUES (109, 1006, '2026-06-19', 'Esperando');  -- Federico
INSERT INTO Lista_de_Espera (ID_Alumno, ID_Clase, Fecha_Solicitud, Estado_Lista_Espera) VALUES (104, 1005, '2026-06-20', 'Esperando');  -- Camila
INSERT INTO Lista_de_Espera (ID_Alumno, ID_Clase, Fecha_Solicitud, Estado_Lista_Espera) VALUES (107, 1009, '2026-06-20', 'Esperando');  -- Nicolás
INSERT INTO Lista_de_Espera (ID_Alumno, ID_Clase, Fecha_Solicitud, Estado_Lista_Espera) VALUES (105, 1006, '2026-06-20', 'Esperando');  -- Tomás
