## Decisiones de Diseño - `Estilo Urbano`
_________________________________________
## Tratamiento de Atributos Específicos:
## Descomposición del Atributo Compuesto `Dirección`
**Decisión:** En la entidad `Cliente` del modelo conceptual, existía el atributo compuesto `Dirección`. En el modelo relacional se desgloso en 3 campos atomicos: `Calle`, `Altura` y `Localidad` dentro de la tabla **`CLIENTE`**.
•Con ello se garantiza la primera forma normal (1FN).
## Separación entre `Precio_Actual` y `Precio_Historico`
**Decisión:** Se mantiene el atributo `Precio_Actual` en la tabla `PRENDA` y el atributo `Precio_Historico` en la tabla intermedia `CONTIENE`
•Mantiene la integridad historica del negocio
_____________________________________________
## Resolución de Relaciones N:M (Muchos a Muchos)
## Detalle de Prendas por Venta (`CONTIENE`).
**Decisión:** La relación entre `VENTA` y `PRENDA` es de muchos a muchos **(Una Venta incluye varias Prendas y una Prenda puede venderse en multiples Ventas)**. Se Resolvió mediante la tabla intermedia `CONTIENE` con una clave primaria compuesta (`fk_VENTA`, `fk_PRENDA`)
•Con ello evitamos la duplicación de datos de la factura y asociamos atributos propios de la línea de detalle como `Cantidad` y `Precio_Historico`.
## Gestión de Pagos Multiples (`ABONA_CON`)
**Decisión:** La relación `VENTA` y `METODO_PAGO` se resolvió mediante la tabla intermedia `ABONA_CON` con clave primaria compuesta (`fk_METODO_PAGO`, `fk_VENTA`).
•Se ortorgo una flexibilidad operativa al negocio, por eso permite que una misma venta sea saldada utilizando mas de un medio de pago **(Efectivo o Tarjeta)**.
_____________________________________________
## Selecciones de Tipos de Datos e Identificadores
## Claves Primarias (PK) númericas:
**Se eligio** `INT` para los identificadores principales (`DNI`, `Nro_Comprobante`, `Codigo_SKU`, `ID_Categoria`, `ID_Metodo`). 
## Atributos Monetarios (`NUNERIC / DECIMAL`):
**Los campos** `Precio_Actual`, `Precio_Historico` y `Monto_Abonado` fueron definidos con tipo numérico de precisión fija **(`NUMERIC(10)`)**.
## Telefono (`NUMERIC`):
**El atributo** `Telofono` de la tabla `CLIENTE` se definio como numérico de 19 digitos **(`NUMERIC(10)`)**.
•Con ello se asegura espacio suficiente para códigos de área y números sin caracteres especiales.
