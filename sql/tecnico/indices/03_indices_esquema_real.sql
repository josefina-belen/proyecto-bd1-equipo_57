/* ============================================================
   ETAPA V - Indices recomendados para el esquema real (OPCIONAL)
   SQL Server NO crea indices automaticamente sobre las claves
   foraneas. Con 8 ventas de prueba la mejora no es medible, pero
   a medida que crezca el volumen estas consultas lo necesitan.
   ============================================================ */
USE PROYECTO;
GO

-- Historial de ventas de un cliente / ventas por rango de fechas
CREATE NONCLUSTERED INDEX IX_VENTA_DNI   ON dbo.VENTA (DNI) INCLUDE (Fecha);
CREATE NONCLUSTERED INDEX IX_VENTA_Fecha ON dbo.VENTA (Fecha);

-- Ventas por prenda (la PK de CONTIENE empieza por Nro_Comprobante)
CREATE NONCLUSTERED INDEX IX_CONTIENE_SKU ON dbo.CONTIENE (Codigo_SKU);

-- Pagos de una venta (la PK de ABONA_CON empieza por ID_Metodo)
CREATE NONCLUSTERED INDEX IX_ABONA_CON_Comprobante ON dbo.ABONA_CON (Nro_Comprobante);
GO
