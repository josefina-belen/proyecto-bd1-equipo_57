USE PROYECTO;
GO

IF OBJECT_ID('dbo.VENTA_HISTORICA', 'U') IS NOT NULL
    DROP TABLE dbo.VENTA_HISTORICA;
GO

CREATE TABLE dbo.VENTA_HISTORICA
(
    Nro_Comprobante BIGINT IDENTITY(1,1) NOT NULL,
    Fecha           DATE          NOT NULL,
    DNI             INT           NOT NULL,
    Total           DECIMAL(12,2) NOT NULL
);
GO

SET NOCOUNT ON;
GO

WITH Numeros AS
(
    SELECT TOP (1000000)
           ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS n
    FROM sys.all_columns a
    CROSS JOIN sys.all_columns b
)
INSERT INTO dbo.VENTA_HISTORICA (Fecha, DNI, Total)
SELECT DATEADD(DAY, ABS(CHECKSUM(NEWID())) % 1825, '2020-01-01'),
       30000000 + ABS(CHECKSUM(NEWID())) % 50000,
       CAST(ABS(CHECKSUM(NEWID())) % 20000000 / 100.0 AS DECIMAL(12,2))
FROM Numeros;
GO

SELECT COUNT(*) AS CantidadRegistros,
       MIN(Fecha) AS Fecha_Min,
       MAX(Fecha) AS Fecha_Max
FROM dbo.VENTA_HISTORICA;
GO
