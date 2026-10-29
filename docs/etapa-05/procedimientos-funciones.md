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
