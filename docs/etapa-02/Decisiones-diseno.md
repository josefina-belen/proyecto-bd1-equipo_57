## Decisiones de Diseño - `Estilo Urbano`
_________________________________________
## Tratamiento de Atributos Específicos:
## Descomposición del Atributo Compuesto `Dirección`
**Decisión:** En la entidad `Cliente` del modelo conceptual, existía el atributo compuesto `Dirección`. En el modelo relacional se desgloso en 3 campos atomicos: `Calle`, `Altura` y `Localidad` dentro de la tabla **`CLIENTE`**.
•Con ello se garantiza la primera forma normal (1FN).
## Separación entre `Precio_Actual` y `Precio_Historico`
**Decisión:** Se mantiene el atributo `Precio_Actual` en la tabla `PRENDA` y el atributo `Precio_Historico` en la tabla intermedia `CONTIENE`
•Mantiene la integridad historica del negocio

