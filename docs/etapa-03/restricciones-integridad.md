# Restricciones de Integridad - **Estilo Urbano (Grupo 57)**

En este documento se detallan y justifican las reglas estructurales y de negocio aplicadas en el esquema físico de la base de datos mediante sentencias DDL en SQL Server.

## 1. Integridad de Dominio (Restricciones CHECK y UNIQUE)

Las restricciones de dominio garantizan que los datos ingresados en las columnas sean válidos y coherentes con la lógica de negocio de la tienda de indumentaria:

*   **Precios y Montos positivos (`> 0`):** Se aplicaron restricciones `CHECK` en `Precio_Actual` (tabla `PRENDA`), `Precio_Historico` (`CONTIENE`) y `Monto_Abonado` (`ABONA_CON`). Esto asegura lógicamente que la tienda no regale mercadería ni registre ingresos nulos o negativos.
*   **Cantidades positivas (`> 0`):** En la tabla `CONTIENE`, el atributo `Cantidad` tiene un `CHECK` para evitar que un cliente compre "0" prendas o una cantidad negativa de artículos en un detalle de venta.
*   **Control de Stock (`>= 0`):** En la tabla `PRENDA`, el `Stock` tiene una restricción `CHECK (Stock >= 0)`. Un artículo puede quedarse sin unidades disponibles (0), pero es físicamente imposible tener un inventario negativo.
*   **Control de Fechas (`<= GETDATE()`):** En la tabla `VENTA`, la `Fecha` cuenta con una validación para asegurar que el registro de la transacción no sea posterior a la fecha y hora actual del servidor. No se pueden registrar ventas en el futuro.
*   **Nombres de Categoría irrepetibles (`UNIQUE`):** Se aplicó a la columna `Nombre` de la tabla `CATEGORIA` para evitar la creación duplicada o redundante de rubros (por ejemplo, cargar dos veces la categoría "Remeras").
