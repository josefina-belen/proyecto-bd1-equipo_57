/* ============================================================
   ETAPA V - Pruebas de indices sobre VENTA_HISTORICA
   Ejecutar de a UN bloque (entre los separadores) con:
     - "Include Actual Execution Plan" activado (Ctrl+M en SSMS)
     - pestana Mensajes visible (STATISTICS IO / TIME)
   Registrar: CPU time, elapsed time, lecturas logicas, operador
   principal y capturar el plan. Repetir cada consulta 3 veces.
   ============================================================ */
USE PROYECTO;
GO
SET STATISTICS TIME ON;
SET STATISTICS IO ON;
GO

/* ---------- Reinicio: dejar la tabla sin indices (heap) ---------- */
IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_VentaHist_Fecha'
           AND object_id = OBJECT_ID('dbo.VENTA_HISTORICA'))
    DROP INDEX IX_VentaHist_Fecha ON dbo.VENTA_HISTORICA;
IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_VentaHist_Fecha_Cobertura'
           AND object_id = OBJECT_ID('dbo.VENTA_HISTORICA'))
    DROP INDEX IX_VentaHist_Fecha_Cobertura ON dbo.VENTA_HISTORICA;
IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_VentaHist_DNI'
           AND object_id = OBJECT_ID('dbo.VENTA_HISTORICA'))
    DROP INDEX IX_VentaHist_DNI ON dbo.VENTA_HISTORICA;
GO

/* ===== ESCENARIO 1: SIN INDICE =====
   Consulta A: ventas de un trimestre */
CHECKPOINT; DBCC DROPCLEANBUFFERS;     -- medicion en frio (solo en entorno de pruebas)
SELECT Nro_Comprobante, Fecha, DNI, Total
FROM dbo.VENTA_HISTORICA
WHERE Fecha BETWEEN '2023-01-01' AND '2023-03-31';
-- Esperado: Table Scan (recorre toda la tabla)
GO

/* ===== ESCENARIO 2: INDICE AGRUPADO (CLUSTERED) SOBRE LA FECHA ===== */
CREATE CLUSTERED INDEX IX_VentaHist_Fecha
ON dbo.VENTA_HISTORICA (Fecha);
GO

CHECKPOINT; DBCC DROPCLEANBUFFERS;
SELECT Nro_Comprobante, Fecha, DNI, Total
FROM dbo.VENTA_HISTORICA
WHERE Fecha BETWEEN '2023-01-01' AND '2023-03-31';
-- Esperado: Clustered Index Seek (lee solo el rango del trimestre)
GO

DROP INDEX IX_VentaHist_Fecha ON dbo.VENTA_HISTORICA;
GO

/* ===== ESCENARIO 3: INDICE CON COBERTURA (NONCLUSTERED + INCLUDE) ===== */
CREATE NONCLUSTERED INDEX IX_VentaHist_Fecha_Cobertura
ON dbo.VENTA_HISTORICA (Fecha)
INCLUDE (Total);
GO

-- Consulta B: solo columnas contenidas en el indice (cubre la consulta)
CHECKPOINT; DBCC DROPCLEANBUFFERS;
SELECT Fecha, Total
FROM dbo.VENTA_HISTORICA
WHERE Fecha BETWEEN '2023-01-01' AND '2023-03-31';
-- Esperado: Index Seek, sin acceder a la tabla

-- Observacion: la Consulta A pide ademas Nro_Comprobante y DNI, que NO estan
-- en el indice. Comparar el plan: puede elegir Table Scan o Seek + RID Lookup.
SELECT Nro_Comprobante, Fecha, DNI, Total
FROM dbo.VENTA_HISTORICA
WHERE Fecha BETWEEN '2023-01-01' AND '2023-03-31';
GO

/* ===== ESCENARIO 4 (caso del negocio): historial de un cliente por DNI ===== */
-- Consulta C sin indice por DNI (solo existe el indice por fecha)
CHECKPOINT; DBCC DROPCLEANBUFFERS;
SELECT Fecha, Total
FROM dbo.VENTA_HISTORICA
WHERE DNI = 30012345;
-- Esperado: Table Scan
GO

CREATE NONCLUSTERED INDEX IX_VentaHist_DNI
ON dbo.VENTA_HISTORICA (DNI)
INCLUDE (Fecha, Total);
GO

CHECKPOINT; DBCC DROPCLEANBUFFERS;
SELECT Fecha, Total
FROM dbo.VENTA_HISTORICA
WHERE DNI = 30012345;
-- Esperado: Index Seek
GO

/* ===== ESPACIO OCUPADO POR CADA ESTRUCTURA ===== */
SELECT ISNULL(i.name, '(tabla sin indice agrupado - heap)') AS Estructura,
       CAST(SUM(ps.used_page_count) * 8 / 1024.0 AS DECIMAL(10,2)) AS MB
FROM sys.indexes i
INNER JOIN sys.dm_db_partition_stats ps
        ON ps.object_id = i.object_id AND ps.index_id = i.index_id
WHERE i.object_id = OBJECT_ID('dbo.VENTA_HISTORICA')
GROUP BY i.name;
GO

/* ===== COSTO EN ESCRITURA: INSERT de 100.000 filas ===== */
SET STATISTICS TIME OFF;
SET STATISTICS IO OFF;
GO

-- (a) Con los 2 indices no agrupados existentes
DECLARE @t0 DATETIME2 = SYSDATETIME();
WITH Numeros AS
(
    SELECT TOP (100000) ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS n
    FROM sys.all_columns a CROSS JOIN sys.all_columns b
)
INSERT INTO dbo.VENTA_HISTORICA (Fecha, DNI, Total)
SELECT DATEADD(DAY, ABS(CHECKSUM(NEWID())) % 1825, '2020-01-01'),
       30000000 + ABS(CHECKSUM(NEWID())) % 50000,
       CAST(ABS(CHECKSUM(NEWID())) % 20000000 / 100.0 AS DECIMAL(12,2))
FROM Numeros;
SELECT DATEDIFF(MILLISECOND, @t0, SYSDATETIME()) AS Insert_100k_CON_indices_ms;
GO

DROP INDEX IX_VentaHist_Fecha_Cobertura ON dbo.VENTA_HISTORICA;
DROP INDEX IX_VentaHist_DNI ON dbo.VENTA_HISTORICA;
GO

-- (b) Sin indices
DECLARE @t0 DATETIME2 = SYSDATETIME();
WITH Numeros AS
(
    SELECT TOP (100000) ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS n
    FROM sys.all_columns a CROSS JOIN sys.all_columns b
)
INSERT INTO dbo.VENTA_HISTORICA (Fecha, DNI, Total)
SELECT DATEADD(DAY, ABS(CHECKSUM(NEWID())) % 1825, '2020-01-01'),
       30000000 + ABS(CHECKSUM(NEWID())) % 50000,
       CAST(ABS(CHECKSUM(NEWID())) % 20000000 / 100.0 AS DECIMAL(12,2))
FROM Numeros;
SELECT DATEDIFF(MILLISECOND, @t0, SYSDATETIME()) AS Insert_100k_SIN_indices_ms;
GO

/* ---------- Limpieza (opcional) ----------
-- DROP TABLE dbo.VENTA_HISTORICA;
*/
