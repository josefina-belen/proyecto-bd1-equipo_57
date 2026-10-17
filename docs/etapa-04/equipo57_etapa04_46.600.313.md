
# Contribución Individual — Etapa 4

**Equipo:** 57  
**Integrantes:** Romero, Josefina Belén y Zalazar, Aldana Georgina  
**Fecha:** 16-10-26

---

## Aporte realizado

Se diseñó y validó una consulta de agregación que consolida las transacciones de la tienda en un rango de fechas, vinculando cuatro tablas del esquema relacional mediante cláusulas `INNER JOIN` (`VENTA`, `CONTIENE`, `PRENDA` y `CATEGORIA`).

Se implementaron las funciones de agregación `COUNT(DISTINCT ...)` y `SUM(...)`, junto con la cláusula `GROUP BY`, para calcular la cantidad de comprobantes emitidos, las prendas vendidas y la recaudación total acumulada.

---

## Problemas o dificultades identificadas

1. **Diferencia entre transacciones únicas y unidades vendidas:** Al principio, intentamos medir las ventas usando un `COUNT` simple sobre la tabla `CONTIENE`, pero identificamos un problema: la función `COUNT` cuenta cuántas filas hay en la base de datos, no cuántas unidades se vendieron. Comprender esta diferencia fue clave para determinar por qué debíamos utilizar `SUM(co.Cantidad)` para sumar las prendas vendidas.

2. **Filtrado por rango de fechas en columnas `DATETIME`:** Determinar cómo manejar correctamente la cláusula `BETWEEN` para evitar excluir las ventas realizadas durante el último día del rango.

3. **Consistencia con el DDL:** Asegurar la correspondencia entre los identificadores de las tablas y las columnas con el script oficial de creación de tablas.

---

## Soluciones

1. Se aplicó `COUNT(DISTINCT v.Nro_Comprobante)` para contar los comprobantes de venta en los que participó cada categoría, `SUM(co.Cantidad)` para calcular la cantidad total de prendas vendidas y `SUM(co.Cantidad * co.Precio_Historico)` para obtener el monto total recaudado.

2. Se ajustaron los límites temporales del filtro a `2026-09-01 00:00:00` y `2026-10-14 23:59:59`, con el objetivo de incluir las operaciones realizadas durante todo el último día del rango.

---

## Evidencia

https://github.com/josefina-belen/proyecto-bd1-equipo_57/blob/main/docs/etapa-04/informe-ventas.md
https://github.com/josefina-belen/proyecto-bd1-equipo_57/blob/main/docs/etapa-04/casos-uso.md

---

## Reflexión

Este apartado fue desarrollado de manera conjunta por ambos integrantes, [@danazalazar](https://github.com/danazalazar) y [@josefina-belen](https://github.com/josefina-belen), mediante la colaboración en el análisis, diseño e implementación.

Aprendimos a combinar múltiples tablas relacionales mediante `INNER JOIN`, utilizar funciones de agregación de forma precisa según el atributo a medir (`COUNT` vs. `SUM`), luego de evaluar ambas posibilidades, y manipular correctamente los rangos de fechas.
