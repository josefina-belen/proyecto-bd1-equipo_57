# Casos de Uso — 

Este documento describe los escenarios operativos y analíticos del negocio que son resueltos mediante las consultas SQL desarrolladas en la Etapa IV.

## 1. Emisión y Consulta de Comprobantes de Venta
**Archivo de referencia:** `comprobante-venta.md`

**Descripción del caso:**
Durante la operatoria diaria, cuando un cliente finaliza una compra o solicita la copia de un ticket anterior (por ejemplo, el comprobante Nro 8), el local necesita visualizar un reporte detallado. 
El sistema ejecuta una consulta que cruza los datos del cliente, consolida el encabezado del comprobante y detalla cada renglón (prenda, precio histórico y cantidad comprada). Finalmente, calcula de forma automática el subtotal por artículo y el total a pagar de la factura completa para entregar al cliente.

---

## 2. Análisis de Rendimiento por Categorías (Reporte Agregado)
**Archivo de referencia:** `informe-ventas.md`

**Descripción del caso:**
Al finalizar un periodo comercial (por ejemplo, del 1 de septiembre al 14 de octubre de 2026), la administración necesita evaluar qué tipos de prendas generan más ingresos. 
El sistema ejecuta este caso de uso para obtener un resumen que agrupa todas las ventas por categoría de indumentaria (Remeras, Pantalones, etc.). Se devuelve la cantidad de comprobantes emitidos, el volumen físico de artículos vendidos y la recaudación total histórica por rubro. Esta información es vital para planificar futuras compras a proveedores y ajustar el stock.

---

## 3. Identificación de Clientes de Alto Valor (Consulta Avanzada)
**Archivo de referencia:** `consulta-avanzada.md`

**Descripción del caso:**
La tienda  desea lanzar una campaña de fidelización (como el envío de cupones de descuento o accesos anticipados a la nueva temporada) orientada a sus mejores compradores.
Para ello, se necesita filtrar la base de datos y obtener un listado exclusivo de los clientes cuyo gasto total acumulado en la tienda sea **superior al gasto promedio general** de todos los compradores. El sistema procesa todas las transacciones, calcula el promedio de gasto por persona y devuelve únicamente los datos de contacto y métricas de los clientes que superan esa barrera.
