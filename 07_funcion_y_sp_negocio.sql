/* ============================================================================
   06 - FUNCION + SP DE NEGOCIO (1 + 1 -> consigna 17.d.iv)
============================================================================ */

USE BD_Pilates;
GO

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
