# Decisiones de Diseño

En base a las reglas de negocio que armamos para el local, dejamos anotadas las decisiones más importantes que tomamos para el sistema:

**1. Clientes registrados por DNI**
Decidimos usar el DNI como el identificador principal y obligatorio para cargar a los clientes. De esta forma nos aseguramos de que cada ticket quede asociado a una persona real y no haya duplicados.

**2. Control de stock por variante exacta**
Para que el inventario no sea un desastre, el sistema va a tratar como productos distintos a las prendas que tengan diferente talle o color, aunque sean del mismo modelo. Así, cuando se venda algo, se descuenta exactamente esa remera o pantalón y evitamos vender cosas que ya no quedan en el local.

**3. Precios fijos en tickets viejos**
Una decisión clave fue guardar el precio unitario de la prenda en el mismo momento que se hace la venta. Si no hacíamos esto, el día de mañana actualizan los precios de la ropa y se nos cambian los totales de todos los comprobantes viejos.

**4. Mantener el sistema simple (alcance)**
Nos apegamos a los requerimientos: el sistema es solo para gestionar las ventas y el catálogo. Decidimos dejar afuera todo lo que sea compras a proveedores, manejo de envíos o devoluciones porque no entran en el alcance de este proyecto.

**5. Requisitos para cobrar una venta**
Para que un ticket sea válido, sí o sí tiene que tener registrado cómo pagó el cliente (efectivo, débito, crédito o transferencia) y tener cargada por lo menos una prenda. El sistema no va a permitir guardar comprobantes vacíos.
