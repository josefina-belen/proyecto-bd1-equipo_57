
Contribución Individual:Etapa 05

![Equipo](https://img.shields.io/badge/Equipo-57-blue) 
![Integrante](https://img.shields.io/badge/Integrante-Alessandro_Sebastián_Rivero-green) 
![Fecha](https://img.shields.io/badge/Fecha-2026--11--03-red)

## 1. Aporte Realizado:
- Encargado de redactar, estructurar y fusionar el archivo **seguridad.md** con la teoría y las pruebas prácticas.
- Configuración de los scripts de seguridad SQL (`01_crear_usuarios_y_roles.sql` y `02_pruebas_seguridad.sql`), creando `Logins`, `Users` y Roles predefinidos y personalizados (como `Rol_Lector_Catalogo`).
- Implementación de un Procedimiento Almacenado (`sp_InsertarCategoria`) para delegar permisos de inserción.
- Ejecución y documentación de las pruebas de acceso (casos válidos e inválidos) verificando las restricciones mediante `EXECUTE AS USER`.

## 2. Decisiones en las que Participe:
Se decidió aplicar el **principio de menor privilegio** para proteger el sistema. Definimos que los empleados de ventas no puedan hacer `INSERT` directo en las tablas, obligándolos a usar Procedimientos Almacenados. Además, acordamos crear un rol exclusivo de solo lectura (`SELECT`) para el personal de depósito, evitando que tengan acceso a datos sensibles de clientes. También se decidió unificar la teoría de seguridad con las capturas de pantalla de una compañera en un solo archivo Markdown para mantener el orden y evitar información duplicada.

## 3. Problemas o dificultades identificadas:
Tuvimos dificultades con el formato del archivo Markdown, ya que al insertar los bloques de código SQL (` ```sql `), el texto normal y las imágenes quedaban atrapados dentro del código, desarmando la estructura visual del documento. Además, hubo diferencias en la sintaxis de las pruebas (el uso de `EXECUTE AS LOGIN` frente a `EXECUTE AS USER`) al integrar los aportes del equipo.

## 4. Solución o Propuesta Realizada:
Para solucionar el formato, corregí la sintaxis de Markdown asegurándome de cerrar cada bloque de código con los tres acentos graves (` ``` `) justo antes de insertar las imágenes desde el celular o la PC. Para el código SQL, integré las correcciones de mi compañera, adaptando todas las pruebas a `EXECUTE AS USER` y organizando el documento paso a paso para que las capturas de validación y de errores (Error 229) coincidan perfectamente con la teoría.

## 5. Evidencia:
https://github.com/josefina-belen/proyecto-bd1-equipo_57/blob/main/sql/tecnico/seguridad/pruebas_seguridad.sql

https://github.com/josefina-belen/proyecto-bd1-equipo_57/blob/main/sql/tecnico/seguridad/crear_usuarios_y_roles.sql

https://github.com/josefina-belen/proyecto-bd1-equipo_57/blob/main/docs/etapa-05/seguridad.md

## 6. Reflexión Individual:
En esta etapa comprendí la importancia crítica de la seguridad en bases de datos y la diferencia entre un Login (servidor) y un Usuario (base de datos). Aprendí cómo los Roles facilitan la administración y cómo los Procedimientos Almacenados son herramientas fundamentales, no solo para programar lógica, sino para proteger la integridad del sistema frente a modificaciones directas no autorizadas.
