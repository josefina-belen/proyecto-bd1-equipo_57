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
