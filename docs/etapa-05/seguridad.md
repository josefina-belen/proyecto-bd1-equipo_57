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

## . Caso concreto aplicado al sistema de ventas del equipo

El caso de aplicación consiste en probar las restricciones de acceso al intentar agregar una nueva categoría de ropa y al consultar el catálogo de prendas.

Se plantean dos situaciones principales:

### Caso : Inserción de datos (Permisos de usuario)

Se intenta registrar la categoría "Camperas" en el sistema. 

- **Caso válido:** El administrador ejecuta la inserción directa y el registro se guarda exitosamente. Asi mismo, cuando un vendedor (que solo tiene permisos de lectura) utiliza el procedimiento almacenado `sp_InsertarCategoria`, la operación también se realiza correctamente gracias a los permisos delegados.
- **Caso inválido:** El vendedor intenta insertar la categoría escribiendo un `INSERT` directamente en la tabla `CATEGORIA`. El sistema detecta la falta de permisos de escritura, genera un error y bloquea la operación.

### Caso : Lectura de catálogo (Permisos por rol)

Se intenta visualizar el stock disponible en la tabla `PRENDA`.

- **Caso válido:** Un empleado de depósito, que fue asignado al rol personalizado `Rol_Lector_Catalogo`, ejecuta la consulta y el sistema le devuelve los datos sin problemas.
- **Caso inválido:** Un empleado de otra área, que no pertenece a dicho rol, intenta ejecutar la misma consulta. El sistema le deniega el acceso y muestra un error en pantalla.

Estos ejemplos demuestran cómo el motor de base de datos protege la información, evitando que usuarios no autorizados lean o modifiquen datos directamente en las tablas.
