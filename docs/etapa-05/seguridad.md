<h1 align="center">Seguridad: Manejo de Permisos a Nivel de Usuarios y Roles</h1>

## Descripción:
En Base de datos, la seguridad es el mecanismo que gestiona quienes pueden acceder al sistema y que acciones especificas tienen permitido realizar sobre la información. En SQL Server, esto de implementa con la creación de inicios de sesión, la asignación de usuarios y la agrupación de permisos s través de **Roles**.

## Objetivo de aplicación en el caso de estudio "👕Estilo Urbano":
Para una tienda de indumentaria como Estilo Urbano, proteger el historial de comprobantes de venta y la integridad del catalogo (precios y stock) es importante. Si cualquier empleado tuviera acceso total, se correría el riesgo de modificaciones erroneas o maliciosas en las tablas base.

Por ello, la seguridad de aplicada para Estilo Urbano  es bajo el **principio de menor privilegio**:
• Se configura una **Autenticación Mixta** para permitir accesos tanto locales como externos.
• Se restringe la escritura directa( `INSERT`, `UPDATE`, `DELETE`) en las tablas transaccionales, obligando a los usuarios a operar de forma segura y controlada exclusivamente a través de **Procedimientos Almacenados**.
• Se crean **Roles Personalizados** (Ej: Personal de Deposito) que delegan únicamente permisos de lectura ( `SELECT` ) sobre tablas especificas como  el catálogo de prendas! evitando tener que asignar permisos uno por uno ante el ingreso de nuevo personal.
