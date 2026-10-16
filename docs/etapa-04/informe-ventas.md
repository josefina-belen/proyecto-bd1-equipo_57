# Informe de Ventas por Categoría

## Descripción de la consulta

El siguiente script SQL resuelve la necesidad de información de un reporte agregado para analizar el rendimiento comercial de la tienda **"Estilo Urbano"**.

La consulta agrupa las transacciones según la categoría de la prenda y calcula los siguientes indicadores:

- **Cantidad de comprobantes emitidos.**
- **Total de unidades físicas vendidas.**
- **Monto recaudado por cada categoría.**

El análisis se realiza dentro de un rango de fechas determinado, desde el **1 de septiembre hasta el 14 de octubre de 2026**.

Para obtener estos resultados, se implementaron las funciones de agregación `COUNT(DISTINCT ...)` y `SUM(...)`, agrupando los datos mediante la cláusula `GROUP BY` sobre los atributos de la categoría (`ID_Categoria` y `Nombre`).

Asimismo, se relacionaron las tablas `VENTA`, `CONTIENE`, `PRENDA` y `CATEGORIA` mediante cláusulas `INNER JOIN`.


## Script SQL

```sql

SELECT
    c.Nombre AS Categoria_Prenda,
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
WHERE v.Fecha BETWEEN '2026-09-01 00:00:00'
                  AND '2026-10-14 23:59:59'
GROUP BY
    c.ID_Categoria,
    c.Nombre
ORDER BY
    Total_Recaudado DESC;
