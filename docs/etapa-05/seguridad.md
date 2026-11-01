<h1 align="center">Seguridad: Manejo de Permisos a Nivel de Usuarios y Roles</h1>

## Descripción:
En Base de datos, la seguridad es el mecanismo que gestiona quienes pueden acceder al sistema y que acciones especificas tienen permitido realizar sobre la información. En SQL Server, esto de implementa con la creación de inicios de sesión, la asignación de usuarios y la agrupación de permisos s través de **Roles**.

## Objetivo de aplicación en el caso de estudio "👕Estilo Urbano":
Para una tienda de indumentaria como Estilo Urbano, proteger el historial de comprobantes de venta y la integridad del catalogo (precios y stock) es importante. Si cualquier empleado tuviera acceso total, se correría el riesgo de modificaciones erroneas o maliciosas en las tablas base.

Por ello, la seguridad de aplicada para Estilo Urbano  es bajo el **principio de menor privilegio**:
**Se** configura una **Autenticación Mixta** para permitir accesos tanto locales como externos.
 **Se** restringe la escritura directa( `INSERT`, `UPDATE`, `DELETE`) en las tablas transaccionales, obligando a los usuarios a operar de forma segura y controlada exclusivamente a través de **Procedimientos Almacenados**.
 **Se** crean **Roles Personalizados** (Ej: Personal de Deposito) que delegan únicamente permisos de lectura ( `SELECT` ) sobre tablas especificas como  el catálogo de prendas! evitando tener que asignar permisos uno por uno ante el ingreso de nuevo personal.

## Ventajas:
**Prevención de errores y fraudes:** Al bloquear el acceso de escritura  directa, se evita que un usuario modifique o borre accidentalmente el stock de una prenda o el total de una venta facturada.
**Administración centralizada y escalable:** Los roles simplifican el mantenimiento.Por ej: de contrata nuevos empleados para el deposito, no es necesario configurar sus permisos tabla por tabla; con asignar su rol correspondiente se soluciona.
**Encapsulamiento de la lógica de negocio:** Al dar permisos de ejecución (`EXECUTE`) sobre Procedimientos almacenados, el sistema asegurá que las inserciones (Registro de ventas)  pasen por todas las validaciones de negocio antes de guardarse en tablas.

## Aplicaciones en "👕Estilo Urbano":
**Personal de Deposito:** Creamos un rol que otorga acceso exclusivo de solo lectura (`SELECT`) al catalogo de la tabla `PRENDA`, esto permite consultar el stock disponible sin riesgo de modificar precios o accesos a datos de la tabla `CLIENTE`.
**Personal de Ventas:** Los vendedores tienen permisos limitados de lectura (`db_datareader`).La única forma en la que se puede registrar nuevos clientes o facturar ropa, es ejecutando los procedimientos Almacenados, esto impide que alteren registros pasados o insertar datos con formato incorrecto.

## Implementación en SQL Server Express:

En nuestro proyecto utilizamos SQL Server Express como sistema gestor de bases de datos y SQL Server Management Studio (SSMS) para configurar la seguridad y ejecutar los scripts.

Para garantizar que el sistema funcione correctamente tanto en un entorno local (con cuentas de Windows) como para conexiones externas, se configuró el motor en **Modo de Autenticación Mixto**. 

La implementación de la seguridad a nivel de base de datos se realiza mediante las siguientes instrucciones y conceptos en SQL Server:

- **`CREATE LOGIN`:** crea un inicio de sesión a nivel de servidor, estableciendo la credencial (usuario y contraseña) para conectarse a la instancia de SQL Server.
- **`CREATE USER`:** crea un usuario específico dentro de la base de datos `PROYECTO` y lo vincula al inicio de sesión previamente creado.
- **Roles fijos de base de datos:** se utilizan roles predefinidos por el motor, como `db_owner` (administrador total) y `db_datareader` (permisos exclusivos de lectura), asignando a los usuarios mediante `ALTER ROLE ... ADD MEMBER`.
- **`CREATE ROLE`:** permite definir roles personalizados adaptados a las reglas de negocio (por ejemplo, un rol exclusivo para consultar el catálogo).
- **`GRANT`:** otorga privilegios específicos a un usuario o rol. En nuestro sistema, se usa `GRANT SELECT` para dar permisos de lectura sobre una tabla particular, y `GRANT EXECUTE` para permitir que un usuario ejecute un Procedimiento Almacenado sin necesidad de darle acceso directo a las tablas subyacentes.

En nuestro sistema, la estrategia consiste en evitar que los usuarios estándar tengan permisos de escritura directa en las tablas. A los empleados de ventas se les asigna un perfil de lectura (`db_datareader`), y cualquier inserción (como registrar un nuevo cliente o una venta) se realiza obligatoriamente a través de la ejecución de Procedimientos Almacenados, protegiendo así la integridad de los datos. Por otro lado, al personal de depósito se le asigna un rol personalizado que solo le permite consultar la tabla `PRENDA`.

## Caso concreto aplicado:

### Seguridad:


   procedimiento almacenado `sp_InsertarCategoria`.

   cuatro logins y sus usuarios correspondientes.

  roles y permisos para cada usuario.


### Parte 1. Crear el procedimiento almacenado

Este procedimiento permitirá insertar categorías sin darle al usuario lector permiso para insertar directamente en la tabla.

```sql
USE PROYECTO;
GO

CREATE PROCEDURE dbo.sp_InsertarCategoria
@Nombre VARCHAR(50)
AS
BEGIN
SET NOCOUNT ON;

INSERT INTO dbo.CATEGORIA (Nombre)

VALUES (@Nombre);

END;
GO

-- Comprobar que se creó correctamente
SELECT name
FROM sys.procedures
WHERE name = 'sp_InsertarCategoria';
GO
```

### Parte 2. Crear los logins y usuarios

Los logins permiten conectarse a SQL Server. Los usuarios permiten acceder a la base de datos PROYECTO con los permisos que les asignemos.




```sql
USE master;
GO

-- 1. Crear los logins del servidor
CREATE LOGIN login_admin
WITH PASSWORD = 'AdministradorUrbano1!';

CREATE LOGIN login_lector
WITH PASSWORD = 'Ventas_Urbano2!';

CREATE LOGIN login_empleado_deposito
WITH PASSWORD = 'Deposito_Urbano1!';

CREATE LOGIN login_empleado_externo
WITH PASSWORD = 'Externo_Urbano1!';
GO

-- 2. Crear los usuarios dentro de PROYECTO


USE PROYECTO;
GO

CREATE USER usr_admin
FOR LOGIN login_admin;

CREATE USER usr_lector
FOR LOGIN login_lector;

CREATE USER usr_con_rol
FOR LOGIN login_empleado_deposito;

CREATE USER usr_sin_rol
FOR LOGIN login_empleado_externo;
GO

-- 3. Comprobar los usuarios creados
SELECT name, type_desc
FROM sys.database_principals
WHERE name IN (
'usr_admin',
'usr_lector',
'usr_con_rol',
'usr_sin_rol'
);
GO
```

### Parte 3. Crear los roles y asignar permisos

Ahora vamos a configurar qué puede hacer cada usuario.

usr_admin: tendrá control total sobre la base de datos.

usr_lector: podrá consultar las tablas y ejecutar el procedimiento almacenado, pero no insertar directamente.

usr_con_rol: podrá consultar la tabla PRENDA mediante un rol personalizado.

usr_sin_rol: no tendrá permiso para consultar PRENDA.

```sql
USE PROYECTO;
GO

-- 1. Asignar rol de administrador
ALTER ROLE db_owner
ADD MEMBER usr_admin;


-- 2. Asignar rol de lector
ALTER ROLE db_datareader
ADD MEMBER usr_lector;


-- 3. Crear el rol personalizado
CREATE ROLE Rol_Lector_Catalogo;


-- 4. Dar permiso de lectura sobre PRENDA
GRANT SELECT ON dbo.PRENDA
TO Rol_Lector_Catalogo;


-- 5. Incorporar al empleado de depósito al rol
ALTER ROLE Rol_Lector_Catalogo
ADD MEMBER usr_con_rol;

-- 6. Permitir al lector ejecutar el procedimiento
GRANT EXECUTE ON OBJECT::dbo.sp_InsertarCategoria
TO usr_lector;
GO

-- 7. Consultar los roles asignados
SELECT
usuario.name AS Usuario,
rol.name AS Rol
FROM sys.database_role_members AS miembros
INNER JOIN sys.database_principals AS rol
ON miembros.role_principal_id = rol.principal_id
INNER JOIN sys.database_principals AS usuario
ON miembros.member_principal_id = usuario.principal_id
WHERE usuario.name IN (
'usr_admin',
'usr_lector',
'usr_con_rol',
'usr_sin_rol'
);
GO
```

**Creados los cuatro usuarios y configurados sus permisos.**


### Parte 4. Pruebas de permisos de usuarios

Primero vamos a probar el administrador. tiene el rol db_owner, por lo tanto, puede insertar directamente en CATEGORIA.

```sql
USE PROYECTO;
GO

EXECUTE AS USER = 'usr_admin';

INSERT INTO dbo.CATEGORIA (Nombre)
VALUES ('Accesorios Urbanos');

REVERT;
GO

SELECT *
FROM dbo.CATEGORIA
WHERE Nombre = 'Accesorios Urbanos';
GO
```
<img width="959" height="256" alt="Screenshot_20261101-145946_Docs" src="https://github.com/user-attachments/assets/6b5b4c4b-5f7c-4bd2-961b-53cc0e19a7c9" />


**B. Caso inválido: lector intentando insertar directamente**

Ahora probaremos que usr_lector no pueda insertar directamente en la tabla.


```sql
USE PROYECTO;
GO

EXECUTE AS USER = 'usr_lector';

INSERT INTO dbo.CATEGORIA (Nombre)
VALUES ('Calzado Urbano');

REVERT;
GO
```
<img width="1042" height="210" alt="Screenshot_20261101-150030_Docs" src="https://github.com/user-attachments/assets/127a245b-bfab-40ee-8354-6b91b199ea52" />


Esto demuestra que el usuario lector no tiene permiso para insertar directamente.


**C. Caso válido: lector utilizando el procedimiento almacenado**

Aunque el lector no puede insertar directamente, sí le otorgamos permiso para ejecutar sp_InsertarCategoria.

El procedimiento se ejecuta correctamente.

Se inserta la categoría Calzado Urbano.

Esto demuestra la delegación de permisos: el usuario no puede insertar directamente, pero puede realizar esa operación mediante el procedimiento autorizado.








```sql
USE PROYECTO;
GO

EXECUTE AS USER = 'usr_lector';

EXEC dbo.sp_InsertarCategoria
@Nombre = 'Calzado Urbano';

REVERT;
GO

SELECT *
FROM dbo.CATEGORIA
WHERE Nombre = 'Calzado Urbano';
GO
```
<img width="772" height="212" alt="Screenshot_20261101-150654_Docs" src="https://github.com/user-attachments/assets/ac9470cd-3fba-4616-b7d3-ddca90131ddb" />

**D. Probar el usuario que pertenece al rol**

Este usuario (usr_con_rol) pertenece al rol Rol_Lector_Catalogo, que tiene permiso para consultar la tabla PRENDA.










```sql

USE PROYECTO;

GO


EXECUTE AS USER = 'usr_con_rol';


SELECT TOP 5 *

FROM dbo.PRENDA;


REVERT;

GO
```
<img width="1071" height="246" alt="Screenshot_20261101-150802_Docs" src="https://github.com/user-attachments/assets/ce644c97-a6ac-4477-ba25-1dafea879e9d" />

**E. Probar el usuario que no pertenece al rol**

Ahora probamos usr_sin_rol, que no tiene permisos de lectura sobre PRENDA.

Esto demuestra que el usuario sin rol no puede consultar esa tabla.









```sql
USE PROYECTO;

GO


EXECUTE AS USER = 'usr_sin_rol';


SELECT TOP 5 *

FROM dbo.PRENDA;


REVERT;

GO
```
<img width="1040" height="209" alt="Screenshot_20261101-151040_Docs" src="https://github.com/user-attachments/assets/001cf301-5859-4497-b46f-4f66a3234ed8" />

Verificación final general para comprobar que quedaron creados los usuarios, los roles y los permisos correctamente en la base PROYECTO.

Verificar usuarios y roles:

```sql
USE PROYECTO;

GO


SELECT

    usuario.name AS Usuario,

    usuario.type_desc AS Tipo,

    rol.name AS Rol

FROM sys.database_role_members AS membresia

INNER JOIN sys.database_principals AS usuario

    ON membresia.member_principal_id = usuario.principal_id

INNER JOIN sys.database_principals AS rol

    ON membresia.role_principal_id = rol.principal_id

WHERE usuario.name IN (

    'usr_admin',

    'usr_lector',

    'usr_con_rol',

    'usr_sin_rol'

)

ORDER BY usuario.name;

GO
```
<img width="998" height="239" alt="Screenshot_20261101-151214_Docs" src="https://github.com/user-attachments/assets/91820c4a-7b22-45eb-bf12-49c644666eab" />

**Verificar los permisos otorgados:**
```sql
USE PROYECTO;

GO


SELECT

    USER_NAME(perm.grantee_principal_id) AS UsuarioORol,

    perm.permission_name AS Permiso,

    perm.state_desc AS Estado,

    OBJECT_NAME(perm.major_id) AS Objeto

FROM sys.database_permissions AS perm

WHERE USER_NAME(perm.grantee_principal_id) IN (

    'usr_lector',

    'Rol_Lector_Catalogo'

)

ORDER BY UsuarioORol, Objeto;

GO
```
<img width="926" height="186" alt="Screenshot_20261101-151315_Docs" src="https://github.com/user-attachments/assets/7110b4cc-62b7-4961-9b23-73cf8313c888" />


**Verificar que existen los usuarios y el procedimiento:** 
```sql
USE PROYECTO;

GO


SELECT name AS Usuario

FROM sys.database_principals

WHERE name IN (

    'usr_admin',

    'usr_lector',

    'usr_con_rol',

    'usr_sin_rol'

);

GO


SELECT name AS Procedimiento

FROM sys.procedures

WHERE name = 'sp_InsertarCategoria';

GO
```
<img width="811" height="902" alt="Screenshot_20261101-151414_Docs" src="https://github.com/user-attachments/assets/a021a487-e88b-48a4-9874-645f63e5af0d" />


**Verificar los inicios de sesión del servidor:**
```sql
USE master;

GO


SELECT name AS Login

FROM sys.server_principals

WHERE name IN (

    'login_admin',

    'login_lector',

    'login_empleado_deposito',

    'login_empleado_externo'

);

GO
```

<img width="1016" height="582" alt="Screenshot_20261101-151509_Docs" src="https://github.com/user-attachments/assets/1a297b1f-52f8-40f8-8c24-b66beb5c14a6" />








## Conclusiones:

  Administrador: pertenece a db_owner y puede realizar operaciones sobre la base de datos.

  Lector: pertenece a db_datareader, puede consultar las tablas y tiene permiso para ejecutar sp_InsertarCategoria, pero no puede insertar directamente en CATEGORIA.

  Empleado con rol: pertenece a Rol_Lector_Catalogo y puede consultar PRENDA.

  Empleado sin rol: no tiene el permiso específico para consultar PRENDA, por lo que SQL Server rechaza la operación.


