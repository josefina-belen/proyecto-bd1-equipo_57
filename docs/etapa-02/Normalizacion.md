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

---
### Eliminción de Grupos Repetitivos:
Se evitaron las listas de datos repetitivos dentro de una misma entidad mediante el uso de tablas intermedias con claves primarias compuestas:
**Detalle prenda por venta (`CONTIENE`):** Para evitar registrar multiples ventas dentro de la misma fila, se creo la tabla intermedia `CONTIENE` . Su clave primaria esta compuesta (`fk_VENTA`, `fk_PRENDA`) y guarda los atributos atómicos `Cantidad` y `Precio_Historico` de cada producto vendido.
**Multiples metodos de pago (`ABONA_CON`):** Para Permitir que una venta  se pague con mas de un medio de pago sin repetir información en `VENTA`, se diseño la tabla intermedia `ABONA_CON`.Su clave primaria esta compuesta (`fk_METODO_PAGO`, `fk_VENTA`) y guarda el `Monto_Abonado` por cada transacción individual. 
