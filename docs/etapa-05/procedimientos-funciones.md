# Tema 1: Procedimientos y funciones almacenadas

### Descripción breve y fundamentos de aplicación
Los procedimientos almacenados y las funciones son bloques de código SQL que se guardan en la base de datos para no tener que escribir las mismas consultas varias 
veces. 
La diferencia es que los procedimientos se usan para ejecutar acciones (como insertar, modificar o borrar datos) y las funciones 
sirven para hacer cálculos y retornar un valor dentro de un `SELECT`.

En nuestro sistema, creamos procedimientos para manejar el alta, baja y modificación de la tabla `CLIENTE`,esto sirve para darle más seguridad a la base de datos, 
evitando que se modifiquen las tablas directamente. 
Tambien, armamos tres 
funciones para resolver tareas repetitivas: concatenar el nombre y apellido del cliente, contar cuántas compras hizo y calcular cuánta plata gastó en total.

### Comparación de eficiencia: Operaciones directas vs. Procedimientos y Funciones
* **Operaciones directas (`INSERT`, `UPDATE`, `DELETE` comunes):** Cada vez que mandamos una consulta suelta, el motor SQL tiene que leerla, revisar que este bien
 y ejecutar desde cero.
* **Procedimientos y funciones:** Como ya están guardados en el servidor, se compilan una sola vez y su plan de ejecución queda en la memoria. Al llamarlos 
con `EXEC`, el motor ejecuta la tarea directo pasando solo los parámetros, lo que ahorra recursos y hace que todo funcione más rápido.

## Casos de aplicacion

# 1. Funciones
**Funcion:** Concatenar el nombre y apellido
- **Problema de negocio:** El sistema necesita mostrar el nombre de los clientes siempre con el mismo formato ("Apellido, Nombre") en todas las     facturas, reportes e historiales de ventas.
- **Funcion Propuesta:**
- <img width="524" height="17" alt="image" src="https://github.com/user-attachments/assets/dcfe6fea-7bd0-4c2a-9853-add326d8137e" />
- **Logica:** Recibe el nombre y el apellido por separado y devuelve un único texto unido por una coma y un espacio (`@Apellido + ', ' + @Nombre`).

**Funcion:** para contar la cantidad total de compras (facturas) de un cliente
- **Problema de negocio:** Conocer rápidamente qué tan frecuente es un cliente contando cuántas facturas o compras tiene registradas a su nombre.
- **Funcion Propuesta:** 
- <img width="313" height="26" alt="image" src="https://github.com/user-attachments/assets/723e3322-f501-4376-978c-9fd953209e35" />
- **Logica:** Cuenta la cantidad de comprobantes (`COUNT(Nro_Comprobante)`) en la tabla `VENTA` asociados a ese DNI (si no tiene compras, devuelve `0`).

**Funcion:** Calcular el monto total histórico gastado por un cliente
- **Problema de negocio:** Saber cuánta plata lleva gastada un cliente en el historial del local para evaluar su nivel de consumo o futuros         beneficios
- **Funcion Propuesta:** 
- <img width="290" height="21" alt="image" src="https://github.com/user-attachments/assets/ebfdc264-4f35-4683-a20a-9a42aae7c258" />
- **Logica:** Une las tablas `VENTA` y `CONTIENE` para multiplicar la cantidad de prendas por su precio histórico (`SUM(D.Cantidad * D.Precio_Historico)`) de todas las compras de ese DNI (si no registra compras, devuelve `0`).

# Uso de las 3 funciones:

<img width="523" height="118" alt="image" src="https://github.com/user-attachments/assets/851643bf-611c-42bc-8241-bf6dd3c7ed36" />

# 2. Procedimientos Almacenados

**Procedimiento: Registrar un nuevo cliente**
- **Problema de negocio:** Dar de alta a un cliente asegurando que se carguen todos sus datos obligatorios de contacto y dirección de una sola vez, sin tocar la tabla directamente.
- **Procedimiento propuesto:**
-  <img width="174" height="19" alt="image" src="https://github.com/user-attachments/assets/9c4194e4-b999-453a-a714-b3dc4f301ebf" />
- **Tareas que realiza:**
  1. Recibe por parámetro el DNI, nombre, apellido, localidad, teléfono, calle y altura.
  2. Inserta el registro completo en la tabla `CLIENTE`.
- **Beneficio:** Estandariza la carga de clientes y evita errores por campos vacíos en el sistema.

**Procedimiento: Modificar datos de un cliente**
- **Problema de negocio:** Actualizar el nombre o apellido de un cliente ya registrado (por ejemplo, si hubo un error de tipeo al cargarlo) buscando por su DNI.
- **Procedimiento propuesto:**
- <img width="185" height="20" alt="image" src="https://github.com/user-attachments/assets/d3b9da45-e753-4e34-9efd-e3d3f609fba7" />
- **Tareas que realiza:**
  1. Busca al cliente en la tabla `CLIENTE` mediante su DNI.
  2. Actualiza las columnas `Nombre` y `Apellido` con los nuevos valores pasados por parámetro.
- **Beneficio:** Permite corregir datos puntuales de forma segura sin riesgo de modificar otros registros por error.

**Procedimiento: Eliminar un cliente**
- **Problema de negocio:** Dar de baja del sistema a un cliente específico de forma rápida y controlada usando únicamente su número de documento.
- **Procedimiento propuesto:**
- <img width="157" height="17" alt="image" src="https://github.com/user-attachments/assets/d7013a38-d947-4fc0-8026-7f3bd8bdf85e" />
- **Tareas que realiza:**
  1. Filtra la tabla `CLIENTE` por el DNI recibido.
  2. Elimina la fila correspondiente.
- **Beneficio:** Simplifica la baja de registros encapsulando el `DELETE` para que no se ejecuten borrados manuales peligrosos sobre la tabla.

## Script de demostracion
<img width="1315" height="589" alt="image" src="https://github.com/user-attachments/assets/e0b3c581-e420-4116-ac5b-540145d949f0" />

## Ejecucion
<img width="1315" height="587" alt="image" src="https://github.com/user-attachments/assets/ed0e75b6-d429-4fad-8480-8a592ce92d1b" />



