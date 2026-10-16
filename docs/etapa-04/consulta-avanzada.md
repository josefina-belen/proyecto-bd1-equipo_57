# Consulta 3 — Clientes con gasto superior al promedio

**Script:** `sql/consultas/consulta_avanzada.sql`

## Necesidad de información que cubra necesidades
Identificar a los clientes más valiosos (los que gastaron más que el cliente promedio) para acciones de fidelización, como descuentos o avisos de nuevos ingresos.

## Estrategia SQL
- **`JOIN` de 4 tablas:** `CLIENTE`, `VENTA`, `CONTIENE` y `PRENDA`.
- `GROUP BY` por cliente: cantidad de compras (`COUNT(DISTINCT Nro_Comprobante)`), categorías distintas compradas (`COUNT(DISTINCT ID_Categoria)`) y gasto total (`SUM(Cantidad * Precio_Historico)`).
- **Filtro condicional con `HAVING` + subconsulta:** se conserva el grupo solo si su gasto total supera el promedio de gasto por cliente, calculado en una subconsulta (suma por cliente y luego `AVG`). Se usa `HAVING` y no `WHERE` porque la condición es sobre un valor agregado.
- El promedio se calcula solo entre clientes que compraron (los que no tienen ventas no entran en el cálculo).

## Resultado esperado (datos de prueba)
Gasto promedio por cliente: 233.000 / 8 = 29.125.

| Cliente | Compras | Categorías | Gasto total |
|---|---|---|---|
| Martinez, Ana | 1 | 1 | 60.000 |
| Gomez, Maria | 1 | 1 | 45.000 |
| Lopez, Carlos | 1 | 1 | 35.000 |
| Sosa, Sofia | 1 | 1 | 30.000 |
