#Proceso de Normalización: Proyecto: "Estilo Urbano"
##1. Primera Forma Normal (1FN).
###Atomicidad de los Atributos:
*Todos los valores almacenados son atómicos y no existen atributos compuestos dentro del modelo relacional:
**Direccion**:En el diagrama conceptual, la entidad `cliente` poseía el atributo compuesto "dirección".Para cumplir con la 1FN, en la tabla `cliente` se desgloso en 3 atributos atómicos individuales: `Calle`, `Altura` y `Localidad`.
**Valores Individuales**: Cada celda contiene un unico valor por registro. `Telefono` en la tabla `Cliente` guarda uno único  número telefónico.
---
###Definición de Claves Primarias Unicas:
Todas las tablas del sistema cuentan con una clave primaria (PK) que  identifica de forma unica a cada registro, evitando filas duplicadas:
**`CLIENTE`**: Se identifica mediante `DNI`.
**`VENTA`**: Se identifica mediante `Nro_Comprobante`.
**`PRENDA`**: Se identifica mediante `Codigo_SKU`.
**`CATEGORIA`**: Se identifica mediante `ID_Categoria`.
**`METODO_PAGO`**: Se identifica mediante `ID_Metodo`.
