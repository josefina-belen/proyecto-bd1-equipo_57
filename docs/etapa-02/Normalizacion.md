#Proceso de Normalización: Proyecto: "Estilo Urbano"
##1. Primera Forma Normal (1FN).
###Atomicidad de los Atributos:
*Todos los valores almacenados son atómicos y no existen atributos compuestos dentro del modelo relacional:
**Direccion**:En el diagrama conceptual, la entidad `cliente` poseía el atributo compuesto "dirección".Para cumplir con la 1FN, en la tabla `cliente` se desgloso en 3 atributos atómicos individuales: `Calle`, `Altura` y `Localidad`.
**Valores Individuales**: Cada celda contiene un unico valor por registro. `Telefono` en la tabla `Cliente` guarda uno único  número telefónico.
