# Contribución Individual — Etapa 5

**Equipo:** 57  
**Integrante:** Romero, Josefina Belén  
**Fecha:** 3 - 11- 26

---

## Aporte realizado

- **Implementación de transacciones SQL** para garantizar la integridad de las operaciones de venta en la base de datos del sistema.
- **Desarrollo de una operación transaccional** que contempla:
  - Registro de la venta.
  - Obtención del número de comprobante.
  - Registro de los productos vendidos, incluyendo el precio histórico y la cantidad.
  - Registro del pago correspondiente.
  - Actualización del stock disponible.
- **Implementación de control transaccional:**
  - `BEGIN TRANSACTION`: inicia la transacción.
  - `COMMIT`: confirma los cambios cuando todas las operaciones se ejecutan correctamente.
  - `ROLLBACK`: revierte los cambios ante errores o incumplimientos de las condiciones establecidas.
- **Incorporación de TRY/CATCH** para capturar errores y controlar la reversión de las operaciones.
- **Validación de disponibilidad de stock**, utilizando `UPDLOCK` para proteger la lectura del inventario durante la operación.

## Problemas o dificultades identificadas

Al principio, me costó comprender la diferencia entre COMMIT y ROLLBACK, especialmente identificar en qué momento correspondía confirmar los cambios realizados y cuándo era necesario revertirlos ante un error.

También tuve dificultades para verificar y mostrar correctamente el stock final después de ejecutar cada transacción, ya que necesitaba comprobar que, ante una venta exitosa, las unidades se descontaran correctamente y que, ante una operación fallida, el stock se mantuviera sin modificaciones

## Soluciones

- Para comprender el funcionamiento de `COMMIT` y `ROLLBACK`, realicé pruebas con distintos escenarios de venta. Pude comprobar que `COMMIT` confirma los cambios cuando la operación finaliza correctamente, mientras que `ROLLBACK` revierte todas las modificaciones cuando se produce un error, evitando que queden datos incompletos.
- Para verificar el stock final, incorporé consultas de comprobación antes y después de ejecutar cada transacción. De esta manera, pude confirmar que, en una venta exitosa, el stock disminuía según la cantidad vendida y que, ante una venta fallida por falta de unidades, el stock permanecía sin cambios.
- Se realizaron pruebas prácticas para comprobar ambos escenarios:
  - **Transacción exitosa:** se registró una venta del producto con SKU 1001, para el cliente con DNI 30111222, por una cantidad de 2 unidades y un total de $30.000. La operación finalizó con `COMMIT` y el stock se redujo de 20 a 18 unidades.
  - **Transacción fallida:** se intentó realizar una venta de 100 unidades cuando solamente había 18 disponibles. La operación generó un error controlado y se ejecutó `ROLLBACK`, evitando que se registrara una venta incompleta y conservando el stock original.

## Reflexión

Profundicé en la importancia de las transacciones para garantizar la integridad y consistencia de los datos.

Comprendí que una operación de venta no consiste únicamente en insertar registros, sino que involucra diferentes tablas y modificaciones que deben ejecutarse de manera coordinada. Aprendí a utilizar `BEGIN TRANSACTION`, `COMMIT` y `ROLLBACK`.

A través de las pruebas realizadas, pude comprobar que las transacciones permiten evitar registros incompletos y mantener la consistencia del inventario.
