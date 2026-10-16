## Decisiones de Diseño - `Estilo Urbano`
_________________________________________
## Tratamiento de Atributos Específicos:
## Descomposición del Atributo Compuesto `Dirección`
**Decisión:** En la entidad `Cliente` del modelo conceptual, existía el atributo compuesto `Dirección`. En el modelo relacional se desgloso en 3 campos atomicos: `Calle`, `Altura` y `Localidad` dentro de la tabla **`CLIENTE`**.
•Con ello se garantiza la primera forma normal (1FN).
## Separación entre `Precio_Actual` y `Precio_Historico`
**Decisión:** Se mantiene el atributo `PrecioActual` en la tabla `PRENDA` y el atributo `PrecioHistorico` en la tabla intermedia `CONTIENE`
•Mantiene la integridad historica del negocio
_____________________________________________
## Resolución de Relaciones N:M (Muchos a Muchos)
## Detalle de Prendas por Venta (`CONTIENE`).
**Decisión:** La relación entre `VENTA` y `PRENDA` es de muchos a muchos **(Una Venta incluye varias Prendas y una Prenda puede venderse en multiples Ventas)**. Se Resolvió mediante la tabla intermedia `CONTIENE` con una clave primaria compuesta (`NroComprobante`, `CodigoSku`)
•Con ello evitamos la duplicación de datos de la factura y asociamos atributos propios de la línea de detalle como `Cantidad` y `PrecioHistorico`.
## Gestión de Pagos Multiples (`ABONA_CON`)
**Decisión:** La relación `VENTA` y `METODO_PAGO` se resolvió mediante la tabla intermedia `ABONA_CON` con clave primaria compuesta (`IdMetodo`, `NroComprobante`).
•Se ortorgo una flexibilidad operativa al negocio, por eso permite que una misma venta sea saldada utilizando mas de un medio de pago **(Efectivo o Tarjeta)**.
_____________________________________________
## Selecciones de Tipos de Datos e Identificadores
## Claves Primarias (PK) númericas:
**Se eligio** `INT` para los identificadores principales (`Dni`, `NroComprobante`, `CodigoSKU`, `IdCategoria`, `IdMetodo`). 
## Atributos Monetarios:
**Los campos** `PrecioActual`, `PrecioHistorico` y `MontoAbonado` fueron definidos con tipo numérico de precisión fija **(`DECIMAL (10,2)`)**.
## Telefono (`VARCHAR`):
**El atributo** `Telofono` de la tabla `CLIENTE` se definio como texto **(`VARCHAR (20)`)**.
•Con ello se asegura espacio suficiente para códigos de área y números sin caracteres especiales.
_____________________________________________
## Integridad Referencial
**Foreign Keys (FK):** Las relaciones entre las tablas se implementan mediante claves foráneas con nombres específicos y reglas de comportamiento asociadas:
* **`FK_VENTA_CLIENTE`** en la tabla `VENTA` apuntando a `Dni` en `CLIENTE`.
* **`FK_PRENDA_CATEGORIA`** en la tabla `PRENDA` apuntando a `IdCategoria` en `CATEGORIA`.
* **`FK_ABONA_CON_METODO_PAGO`** y **`FK_ABONA_CON_VENTA`** en la tabla intermedia `ABONA_CON`.
* **`FK_CONTIENE_VENTA`** y **`FK_CONTIENE_PRENDA`** en la tabla intermedia `CONTIENE`.
Todas apuntan directamente a la Clave Primaria de la tabla origen, aplicando reglas de `ON DELETE CASCADE`, `ON DELETE NO ACTION` y `ON UPDATE CASCADE`.

