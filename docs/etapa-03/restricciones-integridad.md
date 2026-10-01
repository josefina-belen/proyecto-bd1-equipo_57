# Restricciones de Integridad - **Estilo Urbano (Grupo 57)**

En este documento se detallan y justifican las reglas estructurales y de negocio aplicadas en el esquema físico de la base de datos mediante sentencias DDL en SQL Server.

## 1. Integridad de Dominio (Restricciones CHECK y UNIQUE)

Las restricciones de dominio garantizan que los datos ingresados en las columnas sean válidos y coherentes con la lógica de negocio de la tienda de indumentaria:

*   **Precios y Montos positivos (`> 0`):** Se aplicaron restricciones `CHECK` en `Precio_Actual` (tabla `PRENDA`), `Precio_Historico` (`CONTIENE`) y `Monto_Abonado` (`ABONA_CON`). Esto asegura lógicamente que la tienda no regale mercadería ni registre ingresos nulos o negativos.
*   **Cantidades positivas (`> 0`):** En la tabla `CONTIENE`, el atributo `Cantidad` tiene un `CHECK` para evitar que un cliente compre "0" prendas o una cantidad negativa de artículos en un detalle de venta.
*   **Control de Stock (`>= 0`):** En la tabla `PRENDA`, el `Stock` tiene una restricción `CHECK (Stock >= 0)`. Un artículo puede quedarse sin unidades disponibles (0), pero es físicamente imposible tener un inventario negativo.
*   **Control de Fechas (`<= GETDATE()`):** En la tabla `VENTA`, la `Fecha` cuenta con una validación para asegurar que el registro de la transacción no sea posterior a la fecha y hora actual del servidor. No se pueden registrar ventas en el futuro.
*   **Nombres de Categoría irrepetibles (`UNIQUE`):** Se aplicó a la columna `Nombre` de la tabla `CATEGORIA` para evitar la creación duplicada o redundante de rubros (por ejemplo, cargar dos veces la categoría "Remeras").
____________________________________________
## 2. Integridad Referencial (Reglas de Borrado y Modificación)

Las reglas de las claves foráneas (FOREIGN KEY) definen cómo reacciona el motor de base de datos ante actualizaciones o eliminaciones en las tablas maestras, garantizando que no queden registros "huérfanos":

*   **Actualizaciones en Cascada (`ON UPDATE CASCADE`):** Se aplicó en todas las claves foráneas del modelo. Si por algún motivo administrativo se corrige la clave primaria de un registro maestro (por ejemplo, se corrige un error de tipeo en el `DNI` de un `CLIENTE` o se actualiza un `Codigo_SKU`), ese cambio se propagará automáticamente a todas las tablas dependientes (`VENTA`, `CONTIENE`, etc.) manteniendo la coherencia de la información sin romper las relaciones.
*   **Eliminaciones en Cascada (`ON DELETE CASCADE`):** Se implementó exclusivamente en las tablas intermedias de detalle: `ABONA_CON` y `CONTIENE`. La justificación es que estas tablas son dependencias débiles de `VENTA`. Si se anula y elimina un comprobante de venta de la base de datos, sus detalles de artículos y sus registros de pago deben desaparecer automáticamente, ya que no tienen sentido de existencia sin su venta madre.
*   **Restricción de Eliminación (`ON DELETE NO ACTION`):** Se utilizó para proteger los datos históricos y maestros. 
    *   De `CLIENTE` a `VENTA`: El sistema impedirá eliminar a un cliente si este ya tiene compras registradas, preservando el historial contable de la tienda.
    *   De `CATEGORIA` a `PRENDA`: No se permitirá borrar una categoría si existen prendas de ropa asociadas a la misma.
    *   De `METODO_PAGO` a `ABONA_CON`: Evita borrar un método de pago si ya fue utilizado en transacciones pasadas.

## 3. Integridad de Entidad (PRIMARY KEY e IDENTITY)

*   Todas las tablas poseen una `PRIMARY KEY` explícita que garantiza la unicidad de cada fila y evita valores nulos en los identificadores.
*   Se delegó al motor de base de datos la generación de claves subrogadas usando `IDENTITY(1,1)` en `ID_Categoria`, `ID_Metodo` y `Nro_Comprobante`, evitando colisiones de concurrencia al momento de insertar registros simultáneos en la tienda.
