USE PROYECTO;
GO

-- 1. Procedimiento para Insertar un cliente
CREATE OR ALTER PROCEDURE dbo.sp_InsertarCliente
    @Dni INT,
    @Nombre VARCHAR(100),
    @Apellido VARCHAR(100),
    @Localidad INT,
    @Telefono VARCHAR(50),
    @Calle VARCHAR(100),
    @Altura INT
AS
BEGIN
    INSERT INTO CLIENTE (Dni, Nombre, Apellido, Localidad, Telefono, Calle, Altura)
    VALUES (@Dni, @Nombre, @Apellido, @Localidad, @Telefono, @Calle, @Altura);
END;
GO

-- 2. Procedimiento para Modificar datos de un cliente
CREATE OR ALTER PROCEDURE dbo.sp_ModificarCliente
    @Dni INT,
    @NuevoNombre VARCHAR(100),
    @NuevoApellido VARCHAR(100)
AS
BEGIN
    UPDATE CLIENTE 
    SET Nombre = @NuevoNombre, 
        Apellido = @NuevoApellido
    WHERE Dni = @Dni;
END;
GO

-- 3. Procedimiento para Borrar un cliente
CREATE OR ALTER PROCEDURE dbo.sp_BorrarCliente
    @Dni INT
AS
BEGIN
    DELETE FROM CLIENTE 
    WHERE Dni = @Dni;
END;
GO

-- 1. Función para formatear el nombre completo
CREATE OR ALTER FUNCTION dbo.fn_NombreCompleto (@Nombre VARCHAR(100), @Apellido VARCHAR(100))
RETURNS VARCHAR(202)
AS
BEGIN
    RETURN @Apellido + ', ' + @Nombre;
END;
GO

-- 2. Función para calcular el monto total histórico gastado por un cliente
CREATE OR ALTER FUNCTION dbo.fn_TotalGastadoCliente (@Dni INT)
RETURNS DECIMAL(12,2)
AS
BEGIN
    DECLARE @Total DECIMAL(12,2);
    
    SELECT @Total = SUM(D.Cantidad * D.Precio_Historico)
    FROM VENTA V
    JOIN CONTIENE D ON V.Nro_Comprobante = D.Nro_Comprobante
    WHERE V.Dni = @Dni;
    
    RETURN ISNULL(@Total, 0);
END;
GO

-- 3. Función para contar la cantidad total de compras (facturas) de un cliente
CREATE OR ALTER FUNCTION dbo.fn_CantidadComprasCliente (@Dni INT)
RETURNS INT
AS
BEGIN
    DECLARE @Cantidad INT;
    
    SELECT @Cantidad = COUNT(Nro_Comprobante)
    FROM VENTA
    WHERE Dni = @Dni;
    
    RETURN ISNULL(@Cantidad, 0);
END;
GO
