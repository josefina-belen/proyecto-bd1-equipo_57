# Decisiones de Diseño

**1. Precios fijos en las ventas viejas**
Decidimos anotar el precio de la ropa directamente adentro del detalle de la venta. Si no hacíamos esto, el día que actualicemos los precios en el local se nos iban a cambiar automáticamente los montos de los tickets viejos y el historial contable nos iba a dar cualquier cosa.

**2. Controlar el stock exacto**
En la tabla de prendas pusimos el codigo_sku como clave principal. Esto sirve para diferenciar la ropa exacta (por ejemplo, remera negra talle M). Así nos aseguramos de que cuando se venda algo, se descuente el stock de esa variante específica y no de un modelo en general.

**3. Evitar renglones repetidos en el ticket**
En el detalle de la venta, la clave primaria está formada por dos cosas juntas: el número de ticket y el código del producto. Esto obliga al sistema a no dejarte cargar la misma prenda en dos renglones separados. Si el cliente lleva dos remeras iguales, directamente se suma un "2" en la columna de cantidad.

**4. Tablas aparte para no repetir texto (3FN)**
Para cumplir con la normalización (3FN), sacamos cosas como las categorías de la ropa y los métodos de pago a tablitas separadas. En vez de escribir la palabra "Tarjeta de débito" repetida en miles de ventas, solo guardamos su ID. Esto evita errores de tipeo y hace que la base de datos sea más limpia.
