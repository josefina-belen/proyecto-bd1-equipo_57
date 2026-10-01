# Implementación de la Base de Datos: Tienda de Ropa

Este documento detalla la lógica de construcción y población de la base de datos `PROYECTO`, diseñada para gestionar el inventario, clientes y transacciones de una tienda de ropa.

## 1. Creación del Esquema (Script DDL)

La estructura de la base de datos se divide en tres niveles lógicos para garantizar la integridad referencial y evitar redundancia de datos.

### Tablas de Catálogo (Entidades Fuertes)
No dependen de ninguna otra tabla para existir.
* **METODO_PAGO:** Almacena las distintas formas de cobro aceptadas (Efectivo, Tarjetas, Transferencias, Billeteras Virtuales). Se identifica con un ID autoincremental.
* **CATEGORIA:** Clasifica los tipos de prendas del catálogo asegurando que los nombres sean únicos (restricción `UNIQUE`).
* **CLIENTE:** Registra los datos personales y de contacto de los compradores. Utiliza el número de DNI real como Clave Primaria en lugar de un ID autoincremental.

### Entidades Transaccionales y de Producto
Dependen directamente de los catálogos para su creación.
* **PRENDA:** Catálogo de artículos disponibles. Se identifica mediante un código SKU. Incluye restricciones (`CHECK`) para evitar que el precio actual sea negativo o que el stock caiga por debajo de cero. Posee una Clave Foránea vinculada a `CATEGORIA`.
* **VENTA:** Actúa como la cabecera del comprobante comercial. Registra la fecha (que no puede ser mayor a la fecha actual) y se vincula al DNI del cliente.

### Tablas de Detalle (Relaciones N:M)
Resuelven las relaciones de "muchos a muchos" mediante claves primarias compuestas y eliminaciones en cascada (`ON DELETE CASCADE`) vinculadas al comprobante.
* **CONTIENE (Detalle de Venta):** Vincula una venta con los SKU comprados. Registra la cantidad y congela el "Precio Histórico" al momento de la compra para que futuros cambios de precio en la tabla `PRENDA` no alteren facturas pasadas.
* **ABONA_CON (Detalle de Pago):** Permite que una única venta se pague combinando diferentes métodos (ej. parte en efectivo, parte con tarjeta). Registra el ID del método y el monto parcial abonado.



e y que las relaciones entre PKs y FKs coincidan.
