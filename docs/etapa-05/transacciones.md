# Transacciones en SQL Server: control de stock en un sistema de ventas

## 1. Definición y objetivo

Una transacción en una base de datos es un conjunto de operaciones que se ejecutan como una única unidad lógica de trabajo. Su objetivo es garantizar que las operaciones relacionadas se completen correctamente en su totalidad o que, si ocurre un error, no queden cambios parciales en la base de datos.

En SQL Server, las transacciones permiten utilizar principalmente dos instrucciones:

- **`COMMIT`:** confirma los cambios realizados durante la transacción y los guarda en la base de datos.
- **`ROLLBACK`:** revierte los cambios realizados durante la transacción cuando ocurre un error.

Las transacciones se relacionan con las propiedades ACID:

- **Atomicidad:** todas las operaciones se realizan correctamente o ninguna queda aplicada parcialmente.
- **Consistencia:** la base de datos mantiene las restricciones y reglas definidas.
- **Aislamiento:** las transacciones concurrentes se controlan para evitar interferencias indebidas.
- **Durabilidad:** una vez confirmados los cambios, estos permanecen guardados.

En nuestro sistema de ventas, el objetivo es garantizar que una venta, su detalle y la actualización del stock se realicen de manera conjunta. De esta forma, evitamos registrar ventas de productos que no tienen existencias suficientes.

## 2. Ventajas y aplicaciones

Las principales ventajas de utilizar transacciones son:

1. **Integridad de los datos:** evitan que una operación incompleta deje información inconsistente.
2. **Control de errores:** permiten cancelar las operaciones cuando ocurre un problema.
3. **Seguridad en las operaciones:** garantizan que los cambios relacionados se confirmen o se reviertan conjuntamente.
4. **Control de concurrencia:** ayudan a coordinar operaciones simultáneas sobre los mismos datos.
5. **Confiabilidad:** permiten mantener la coherencia entre las ventas, los pagos y el inventario.

En particular, en una tienda de ropa son importantes porque permiten evitar que se vendan más unidades de las disponibles y que el inventario quede desactualizado.

## 3. Implementación en SQL Server Express

En nuestro proyecto utilizamos SQL Server Express como sistema gestor de bases de datos y SQL Server Management Studio (SSMS) para ejecutar las consultas y los scripts SQL.

La implementación de una transacción se realiza mediante las siguientes instrucciones:

- **`BEGIN TRANSACTION`:** inicia la transacción.
- **`COMMIT TRANSACTION`:** confirma todos los cambios realizados correctamente.
- **`ROLLBACK TRANSACTION`:** revierte los cambios de la transacción.
- **`BEGIN TRY` y `BEGIN CATCH`:** permiten controlar los errores producidos durante la ejecución.
- **`@@TRANCOUNT`:** permite comprobar si existe una transacción activa.
- **`UPDLOCK`:** solicita un bloqueo de actualización sobre los datos consultados, ayudando a evitar conflictos cuando varias operaciones intentan modificar el mismo stock.

En nuestro sistema, primero se consulta el stock disponible y se verifica que alcance para la cantidad solicitada. Si la validación es satisfactoria, se registra la venta, se inserta el detalle, se registra el pago y se descuenta el stock. Finalmente, se ejecuta `COMMIT`.

Si el stock es insuficiente o se produce un error, se ejecuta el bloque `CATCH` y se utiliza `ROLLBACK` para revertir las operaciones realizadas dentro de la transacción.

## 4. Caso concreto aplicado al sistema de ventas del equipo

El caso de aplicación consiste en registrar la venta de cinco unidades de una prenda de ropa identificada con el código SKU 1001.

El producto es una Remera Basic, cuyo precio histórico de venta es de $15.000 por unidad. La venta se asocia al cliente con DNI 30111222 y al método de pago identificado con el número 1.

La operación comprende:

1. Consultar el stock disponible de la prenda.
2. Verificar que el producto exista y que haya unidades suficientes.
3. Registrar la venta en la tabla `VENTA`.
4. Registrar el detalle en la tabla `CONTIENE`.
5. Registrar el pago en la tabla `ABONA_CON`.
6. Descontar las unidades vendidas del stock de la tabla `PRENDA`.
7. Confirmar o revertir la transacción según el resultado.

Se plantean dos situaciones:

### Caso válido

El producto cuenta con 18 unidades y el cliente compra cinco. La operación se realiza correctamente, se registra la venta y el detalle, y el stock disminuye de 18 a 13 unidades.

El importe total es de $75.000 y la transacción finaliza con `COMMIT`.

### Caso inválido

Se intenta vender 100 unidades cuando solamente hay 13 disponibles. El sistema detecta el stock insuficiente, genera un error controlado y ejecuta `ROLLBACK`.

Como consecuencia, no se registra una nueva venta ni su detalle, no se registra el pago y el stock permanece en 13 unidades.

Este ejemplo demuestra cómo las transacciones protegen la integridad del sistema de ventas.

## 5. Script de demostración y resultados obtenidos

### Prueba 1: venta correcta

Resultado luego de ejecución de 5 productos:

<img width="659" height="334" alt="image" src="https://github.com/user-attachments/assets/f6fc6309-8584-4d53-8805-7a9c42fe22b0" />

Stock actualizado y venta registrada: 

<img width="578" height="388" alt="image" src="https://github.com/user-attachments/assets/9dbbdd4c-8468-445b-a80b-c303dd4c9afb" />


### Prueba 2: venta con stock insuficiente

Venta invalida por stock insuficiente:

<img width="773" height="84" alt="image" src="https://github.com/user-attachments/assets/e0ef32a5-454a-4457-9a56-4d47d03cc9bf" />

El stock no cambió y que no se registró una venta nueva por el intento fallido:

<img width="573" height="409" alt="image" src="https://github.com/user-attachments/assets/1aec57b5-e864-4362-9a3c-9766217da7ee" />


## Conclusión

La implementación de transacciones permite que el sistema de ventas mantenga la coherencia entre las ventas, sus detalles, los pagos y el inventario.

Las pruebas realizadas demuestran el funcionamiento de `COMMIT` para confirmar una operación exitosa y de `ROLLBACK` para cancelar una operación inválida. De esta manera, se evidencia la importancia de la atomicidad en la gestión de las operaciones comerciales.
