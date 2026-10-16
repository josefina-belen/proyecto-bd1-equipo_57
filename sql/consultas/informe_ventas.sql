USE PROYECTO; 
GO 
--  -- REPORTE AGREGADO POR CATEGORÍA DE PRODUCTO -- 
SELECT c.Nombre AS Categoria_Prenda,
COUNT(DISTINCT v.Nro_Comprobante) AS Cantidad_Comprobantes,

 SUM(co.Cantidad) AS Cantidad_Articulos_Vendidos,

SUM(co.Cantidad * co.Precio_Historico) AS Total_Recaudado 

FROM VENTA v 
INNER JOIN CONTIENE co 
ON v.Nro_Comprobante = co.Nro_Comprobante 
INNER JOIN PRENDA p 
ON co.Codigo_SKU = p.Codigo_SKU 
INNER JOIN CATEGORIA c 
ON p.ID_Categoria = c.ID_Categoria 
WHERE v.Fecha BETWEEN '2026-09-01 00:00:00' AND '2026-10-14 23:59:59' 
GROUP BY c.ID_Categoria, c.Nombre 
ORDER BY 
Total_Recaudado DESC;
