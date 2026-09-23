# Decisiones de Diseño - Sistema de Gestión de Indumentaria

Este documento detalla las principales decisiones arquitectónicas y de modelado relacional tomadas para garantizar la integridad, consistencia y escalabilidad de la base de datos.

### 1. Manejo del Historial de Precios (Desnormalización Controlada)
Para cumplir con la regla de negocio que exige mantener inalterables los valores de las ventas pasadas frente a futuros aumentos de tarifas, se decidió implementar la captura del precio histórico. 
* **Decisión:** La tabla intermedia `detalle_venta` almacena una copia estática del atributo `precio_unitario` en el momento exacto de la transacción. 
* **Justificación:** Si el detalle de la venta referenciara únicamente al precio actual alojado en la tabla `prenda`, cualquier actualización en la lista de precios alteraría retroactivamente los montos de los comprobantes ya emitidos, rompiendo la auditoría contable.

### 2. Gestión de Variantes de Indumentaria (Talle y Color)
La indumentaria requiere un control de stock preciso que diferencie el mismo modelo en distintas variantes físicas.
* **Decisión:** Se definió que el atributo `codigo_sku` (Stock Keeping Unit) actúe como Clave Primaria (PK) representando a una variante específica, y no a un modelo genérico. 
* **Justificación:** Una remera modelo "Básica" en talle M y color Negro tiene un código SKU distinto a la misma remera en talle L. Esto permite que el atributo `stock` refleje las existencias reales de cada variante física, evitando inconsistencias al momento de descontar unidades en una venta.

### 3. Claves Primarias Compuestas en Entidades Intermedias
Para la resolución de la relación de muchos a muchos (N:M) entre las ventas y las prendas adquiridas.
* **Decisión:** La tabla `detalle_venta` utiliza una Clave Primaria compuesta formada por `nro_comprobante` y `codigo_sku`.
* **Justificación:** Esta restricción garantiza que un mismo artículo no pueda registrarse en múltiples renglones separados dentro de un mismo comprobante. Si un cliente adquiere dos unidades idénticas, el sistema actualiza el atributo `cantidad` en el renglón correspondiente, asegurando la atomicidad y cumpliendo con la Segunda Forma Normal (2FN).

### 4. Aislamiento de Entidades Auxiliares (3FN)
Para evitar anomalías de actualización y mantener el esquema en Tercera Forma Normal (3FN).
* **Decisión:** Conceptos como "Categoría" (Pantalones, Remeras, etc.) y "Método de Pago" (Efectivo, Tarjeta) fueron extraídos a tablas paramétricas independientes.
* **Justificación:** Las descripciones en texto de las categorías o los pagos dependen exclusivamente de sus propios identificadores. Mantener estos textos estandarizados en tablas aisladas y referenciarlos mediante Claves Foráneas (FK) elimina la redundancia de datos y facilita el filtrado en futuras consultas SQL agregadas.
