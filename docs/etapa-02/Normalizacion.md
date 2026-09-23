# Proceso de Normalización: Proyecto: "Estilo Urbano"
## 1. Primera Forma Normal (1FN).
### Atomicidad de los Atributos:
*Todos los valores almacenados son atómicos y no existen atributos compuestos dentro del modelo relacional:
**Direccion**:En el diagrama conceptual, la entidad `cliente` poseía el atributo compuesto "dirección".Para cumplir con la 1FN, en la tabla `cliente` se desgloso en 3 atributos atómicos individuales: `Calle`, `Altura` y `Localidad`.
**Valores Individuales**: Cada celda contiene un unico valor por registro. `Telefono` en la tabla `Cliente` guarda uno único  número telefónico.

---

### Definición de Claves Primarias Unicas:
Todas las tablas del sistema cuentan con una clave primaria (PK) que  identifica de forma unica a cada registro, evitando filas duplicadas:
**`CLIENTE`**: Se identifica mediante `DNI`.
**`VENTA`**: Se identifica mediante `Nro_Comprobante`.
**`PRENDA`**: Se identifica mediante `Codigo_SKU`.
**`CATEGORIA`**: Se identifica mediante `ID_Categoria`.
**`METODO_PAGO`**: Se identifica mediante `ID_Metodo`.


## Segunda forma normal 2FN

Tomando la estructura resultante de la 1FN:

### Grupo A: Tablas con Clave Primaria Simple

1. **CLIENTE** — PK: `DNI`
2. **VENTA** — PK: `Nro_Comprobante`
3. **PRENDA** — PK: `Codigo_SKU`
4. **CATEGORIA** — PK: `ID_Categoria`
5. **METODO_PAGO** — PK: `ID_Metodo`

Como sus claves primarias son atómicas (un solo campo), **no pueden tener dependencias parciales** y están **automáticamente en 2FN**.

---

### Grupo B: Tablas con Clave Primaria Compuesta

#### 1. Tabla CONTIENE

- **Clave Primaria Compuesta:** (`fk_VENTA`, `fk_PRENDA`)
- **Atributos No Clave:**
  - `Cantidad`
  - `Precio_Historico`

**Análisis de dependencias:**

- **Cantidad:** depende de la combinación de la venta y la prenda:

  `(`fk_VENTA`, `fk_PRENDA`) → Cantidad`

  Es una **dependencia completa**.

- **Precio_Historico:** de acuerdo con la regla de negocio **RN.03**, captura el precio cobrado en el instante exacto de la operación. Depende tanto del comprobante como del producto vendido:

  `(`fk_VENTA`, `fk_PRENDA`) → Precio_Historico`

  Es una **dependencia completa**.

**Resultado:** No existen dependencias parciales. La tabla **CONTIENE cumple con la 2FN**.

---

#### 2. Tabla ABONA_CON

- **Clave Primaria Compuesta:** (`fk_METODO_PAGO`, `fk_VENTA`)
- **Atributo No Clave:** `Monto_Abonado`

**Análisis de dependencias:**

- **Monto_Abonado:** depende de ambos atributos de la clave:

  `(`fk_METODO_PAGO`, `fk_VENTA`) → Monto_Abonado`

  Es una **dependencia completa**.

**Resultado:** No existen dependencias parciales. La tabla **ABONA_CON cumple con la 2FN**.

---
### Eliminción de Grupos Repetitivos:
Se evitaron las listas de datos repetitivos dentro de una misma entidad mediante el uso de tablas intermedias con claves primarias compuestas:
**Detalle prenda por venta (`CONTIENE`):** Para evitar registrar multiples ventas dentro de la misma fila, se creo la tabla intermedia `CONTIENE` . Su clave primaria esta compuesta (`fk_VENTA`, `fk_PRENDA`) y guarda los atributos atómicos `Cantidad` y `Precio_Historico` de cada producto vendido.
**Multiples metodos de pago (`ABONA_CON`):** Para Permitir que una venta  se pague con mas de un medio de pago sin repetir 

## Tercera Forma Normal (3FN)

Partiendo de la estructura resultante de la 2FN, se analizó cada tabla para detectar dependencias transitivas, es decir, atributos no clave que dependieran de otro atributo no clave en lugar de depender directamente de la clave primaria.

## Tablas con Clave Primaria Compuesta

Las tablas **`CONTIENE`** y **`ABONA_CON`** quedan automáticamente en 3FN: sus únicos atributos no clave (`Cantidad`, `Precio_Historico`, `Monto_Abonado`) dependen exclusivamente de la clave compuesta completa, y no existe dependencia alguna entre ellos.

## Tablas con Clave Primaria Simple
## 1. Tabla CLIENTE — PK: DNI
Atributos no clave: `Nombre`, `Apellido`, `Telefono`, `Calle`, `Altura`, `Localidad`.
Análisis: Todos los atributos describen directamente al cliente identificado por **`DNI`** y son independientes entre sí. Ninguno de ellos determina el valor de otro (por ejemplo, `Localidad` no determina `Calle`, ni `Nombre` determina `Telefono`).
Resultado: No existen dependencias transitivas. `CLIENTE` cumple con la 3FN.
## 2. Tabla VENTA — PK: Nro_Comprobante
Atributos no clave: `Fecha`, `DNI` (FK).
Análisis: Fecha depende directamente del comprobante de venta. `DNI` es una clave foránea que vincula la venta con el cliente, pero no almacena datos descriptivos del cliente (esos residen en `CLIENTE`), por lo que no se genera dependencia transitiva.
Resultado: **`VENTA`** cumple con la 3FN.
## 3. Tabla PRENDA — PK: Codigo_SKU
Atributos no clave: `Talle`, `Color`, `Precio_Actual`, `Stock`, `Modelo`, `ID_Categoria` (FK).
Análisis: Todos los atributos describen directamente a la prenda identificada por `Codigo_SKU`. `ID_Categoria` es una clave foránea que referencia a `CATEGORIA`, pero el Nombre de la categoría no se repite dentro de `PRENDA` (se mantiene únicamente en la tabla `CATEGORIA`), evitando así que `Talle`, `Color`, `Precio_Actual`, `Stock` o `Modelo` dependan transitivamente de `ID_Categoria` a través de un atributo descriptivo de la categoría.
Resultado: No existen dependencias transitivas. **`PRENDA`** cumple con la 3FN.
## 4. Tabla CATEGORIA — PK: ID_Categoria
Atributo no clave: Nombre.
Análisis: Al tratarse de un único atributo no clave, no puede existir dependencia transitiva.
Resultado: `CATEGORIA` cumple con la 3FN.
## 5. Tabla METODO_PAGO — PK: ID_Metodo
Atributo no clave: Descripcion.
Análisis: Al tratarse de un único atributo no clave, no puede existir dependencia transitiva.
Resultado: `METODO_PAGO` cumple con la 3FN.
Conclusión

Ninguna tabla del modelo relacional presenta dependencias transitivas entre atributos no clave. Todos los atributos descriptivos dependen exclusivamente de la clave primaria de su propia tabla, y las relaciones entre entidades se resuelven mediante claves foráneas (`fk_Categoria` en `PRENDA`, `fk_Cliente` en `VENTA`) sin duplicar información. En consecuencia, el modelo relacional completo del proyecto "Estilo Urbano" cumple con la Tercera Forma Normal (3FN).información en `VENTA`, se diseño la tabla intermedia `ABONA_CON`.Su clave primaria esta compuesta (`fk_METODO_PAGO`, `fk_VENTA`) y guarda el `Monto_Abonado` por cada transacción individual. 
