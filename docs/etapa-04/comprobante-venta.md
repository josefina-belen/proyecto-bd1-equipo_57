## Consulta de Emisión de Comprobante / Factura

**Objetivo:** Obtener el detalle completo de una venta específica (factura), integrando los datos del cliente, los productos adquiridos, los subtotales por renglón y el cálculo del total general de la factura mediante funciones analíticas.

### Estructura y Funcionamiento:
1. **Unión de Tablas:**
  Conecta la tabla principal **`VENTA`** (`V`) con **`CLIENTE`** (`C`) para recuperar los datos personales del comprador.
   Relaciona la venta con la tabla intermedia **`CONTIENE`** (`D`) y la tabla **`PRENDA`** (`P`) para listar los productos que componen la factura junto con su modelo, cantidad y el precio histórico registrado al momento de la venta.

2. **Columnas Calculadas:**
   **`Subtotal_Renglon`**: Multiplica la `Cantidad` por el `PrecioHistorico` de cada ítem para obtener el monto parcial de esa prenda.
   **`Total_Factura`**: Utiliza una **función de ventana** (`SUM() OVER (PARTITION BY V.NroComprobante)`) para sumar los subtotales de todos los renglones pertenecientes a la misma factura, devolviendo el monto total a abonar sin necesidad de agrupar los registros de detalle.

3. **Filtrado:**
    La cláusula `WHERE V.NroComprobante = 1` permite aislar y consultar el comprobante de una venta en particular (funciona como parámetro para buscar una factura específica).
