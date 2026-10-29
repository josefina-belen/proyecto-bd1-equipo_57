-- =============================================
-- VENTA CON CONTROL DE STOCK Y TRANSACCIONES
-- =============================================


DECLARE @SKU INT = 1001;
DECLARE @Cantidad INT = 5;
DECLARE @DNI_Cliente INT = 30111222;
DECLARE @MetodoPago INT = 1;
DECLARE @PrecioHistorico DECIMAL(10,2) = 15000.00;

DECLARE @MontoTotal DECIMAL(10,2);
DECLARE @StockActual INT;
DECLARE @NuevoComprobante INT;

SET @MontoTotal = @PrecioHistorico * @Cantidad;

BEGIN TRY

    BEGIN TRANSACTION;

    -- 1. Consultar el stock disponible
    SELECT @StockActual = Stock
    FROM dbo.PRENDA WITH (UPDLOCK)
    WHERE Codigo_SKU = @SKU;

    -- 2. Verificar que el producto exista
    IF @StockActual IS NULL
    BEGIN
        RAISERROR('La prenda no existe.', 16, 1);
    END;

    -- 3. Verificar que haya stock suficiente
    IF @StockActual < @Cantidad
    BEGIN
        RAISERROR('Stock insuficiente. No se puede realizar la venta.', 16, 1);
    END;

    -- 4. Registrar la venta
    INSERT INTO dbo.VENTA (Fecha, DNI)
    VALUES (GETDATE(), @DNI_Cliente);

    SET @NuevoComprobante = SCOPE_IDENTITY();

    -- 5. Registrar el detalle de la venta
    INSERT INTO dbo.CONTIENE
        (Nro_Comprobante, Codigo_SKU, Precio_Historico, Cantidad)
    VALUES
        (@NuevoComprobante, @SKU, @PrecioHistorico, @Cantidad);

    -- 6. Registrar el pago
    INSERT INTO dbo.ABONA_CON
        (ID_Metodo, Nro_Comprobante, Monto_Abonado)
    VALUES
        (@MetodoPago, @NuevoComprobante, @MontoTotal);

    -- 7. Descontar el stock vendido
    UPDATE dbo.PRENDA
    SET Stock = Stock - @Cantidad
    WHERE Codigo_SKU = @SKU;

    -- 8. Confirmar todos los cambios
    COMMIT TRANSACTION;

    PRINT 'VENTA EXITOSA: COMMIT realizado.';
    PRINT 'Comprobante Nro: '
        + CAST(@NuevoComprobante AS VARCHAR(20));
    PRINT 'Cantidad vendida: '
        + CAST(@Cantidad AS VARCHAR(10));
    PRINT 'Monto total: $'
        + CAST(@MontoTotal AS VARCHAR(20));

END TRY

BEGIN CATCH

    -- 9. Revertir los cambios si ocurre un error
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;

    PRINT 'ROLLBACK EJECUTADO: '
        + ERROR_MESSAGE();

END CATCH;
GO

-- =============================================
-- Stock actualizado y venta  registrada
-- =============================================

USE PROYECTO;
GO

SELECT Codigo_SKU, Modelo, Stock
FROM dbo.PRENDA
WHERE Codigo_SKU = 1001;

SELECT TOP 1 *
FROM dbo.VENTA
ORDER BY Nro_Comprobante DESC;

SELECT TOP 1 *
FROM dbo.CONTIENE
ORDER BY Nro_Comprobante DESC;
GO

-- =============================================
--  Venta invalida 
-- =============================================

USE PROYECTO;
GO

DECLARE @SKU INT = 1001;
DECLARE @Cantidad INT = 100;
DECLARE @DNI_Cliente INT = 30111222;
DECLARE @MetodoPago INT = 1;
DECLARE @PrecioHistorico DECIMAL(10,2) = 15000.00;
DECLARE @StockActual INT;
DECLARE @NuevoComprobante INT;

BEGIN TRY
    BEGIN TRANSACTION;

    -- 1. Consultar el stock
    SELECT @StockActual = Stock
    FROM dbo.PRENDA WITH (UPDLOCK)
    WHERE Codigo_SKU = @SKU;

    -- 2. Validar existencia y cantidad disponible
    IF @StockActual IS NULL
        RAISERROR('La prenda no existe.', 16, 1);

    IF @StockActual < @Cantidad
        RAISERROR('Stock insuficiente. No se puede realizar la venta.', 16, 1);

    -- 3. Registrar la venta
    INSERT INTO dbo.VENTA (Fecha, DNI)
    VALUES (GETDATE(), @DNI_Cliente);

    SET @NuevoComprobante = SCOPE_IDENTITY();

    -- 4. Registrar el detalle
    INSERT INTO dbo.CONTIENE
        (Nro_Comprobante, Codigo_SKU, Precio_Historico, Cantidad)
    VALUES
        (@NuevoComprobante, @SKU, @PrecioHistorico, @Cantidad);

    -- 5. Registrar el pago
    INSERT INTO dbo.ABONA_CON
        (ID_Metodo, Nro_Comprobante, Monto_Abonado)
    VALUES
        (@MetodoPago, @NuevoComprobante, @PrecioHistorico * @Cantidad);

    -- 6. Descontar stock
    UPDATE dbo.PRENDA
    SET Stock = Stock - @Cantidad
    WHERE Codigo_SKU = @SKU;

    COMMIT TRANSACTION;

    PRINT 'VENTA EXITOSA: COMMIT realizado.';

END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;

    PRINT 'ROLLBACK EJECUTADO: ' + ERROR_MESSAGE();
END CATCH;
GO

-- =============================================
--  Comprueba que el stock no cambio
-- =============================================
USE PROYECTO;
GO

SELECT Codigo_SKU, Modelo, Stock
FROM dbo.PRENDA
WHERE Codigo_SKU = 1001;

SELECT *
FROM dbo.VENTA
ORDER BY Nro_Comprobante DESC;

SELECT *
FROM dbo.CONTIENE
ORDER BY Nro_Comprobante DESC;
GO



