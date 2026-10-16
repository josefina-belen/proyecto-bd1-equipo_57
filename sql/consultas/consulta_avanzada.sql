USE PROYECTO;
GO

SELECT
    cl.DNI,
    cl.Apellido + ', ' + cl.Nombre                          AS Cliente,
    cl.Localidad,
    COUNT(DISTINCT v.Nro_Comprobante)                       AS Cant_Compras,
    COUNT(DISTINCT pr.ID_Categoria)                         AS Categorias_Distintas,
    SUM(co.Cantidad * co.Precio_Historico)                  AS Gasto_Total
FROM CLIENTE cl
INNER JOIN VENTA    v  ON v.DNI             = cl.DNI
INNER JOIN CONTIENE co ON co.Nro_Comprobante = v.Nro_Comprobante
INNER JOIN PRENDA   pr ON pr.Codigo_SKU      = co.Codigo_SKU
GROUP BY cl.DNI, cl.Apellido, cl.Nombre, cl.Localidad
HAVING SUM(co.Cantidad * co.Precio_Historico) >
       (SELECT AVG(g.Gasto)
        FROM (SELECT SUM(co2.Cantidad * co2.Precio_Historico) AS Gasto
              FROM VENTA v2
              INNER JOIN CONTIENE co2 ON co2.Nro_Comprobante = v2.Nro_Comprobante
              GROUP BY v2.DNI) AS g)
ORDER BY Gasto_Total DESC;
GO
