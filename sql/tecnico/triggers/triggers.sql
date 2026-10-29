-- =====================================================================
--   PARTE 1: tablas de auditoría y triggers (instalación)
--   PARTE 2: script de demostración (pruebas 1 a 7 + consultas de auditoría)
-- =====================================================================

-- #####################################################################
-- PARTE 1 - INSTALACIÓN
-- #####################################################################

-- =====================================================================
-- Requiere : haber ejecutado antes sql/ddl/crear_bd.sql
-- Pruebas  : PARTE 2 de este mismo archivo


-- QUÉ HACE ESTE SCRIPT
--   1) Crea dos tablas de auditoría: AUDITORIA_PRENDA y AUDITORIA_CLIENTE.
--   2) Crea 4 triggers AFTER que guardan el registro ANTES del cambio
--      (y el valor nuevo en los UPDATE), con fecha, hora y usuario:
--         PRENDA  -> trg_PRENDA_AuditoriaUpdate / trg_PRENDA_AuditoriaDelete
--         CLIENTE -> trg_CLIENTE_AuditoriaUpdate / trg_CLIENTE_AuditoriaDelete
--   3) Crea 1 trigger INSTEAD OF que BLOQUEA el DELETE sobre VENTA y
--      emite un mensaje de error:
--         VENTA   -> trg_VENTA_BloquearDelete
--
-- El script es re-ejecutable: no falla si se corre más de una vez.
-- =====================================================================

USE PROYECTO;
GO

-- =====================================================================
-- 1. TABLAS DE AUDITORÍA
--    Columnas *_Anterior : valores que tenía el registro ANTES del cambio
--                          (siempre se completan).
--    Columnas *_Nuevo    : valores DESPUÉS del cambio (solo en UPDATE;
--                          quedan en NULL en un DELETE).
-- =====================================================================

IF OBJECT_ID('dbo.AUDITORIA_PRENDA', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.AUDITORIA_PRENDA
    (
        ID_Auditoria          INT IDENTITY(1,1) NOT NULL,
        Operacion             VARCHAR(6)    NOT NULL,   -- 'UPDATE' o 'DELETE'
        Fecha_Hora            DATETIME2(3)  NOT NULL,
        Usuario_Login         SYSNAME       NOT NULL,   -- login que ejecutó la operación
        Usuario_BD            SYSNAME       NOT NULL,   -- usuario de la base de datos

        -- Valores ANTERIORES (registro antes del cambio)
        Codigo_SKU_Anterior   INT           NOT NULL,
        Talle_Anterior        VARCHAR(10)   NOT NULL,
        Color_Anterior        VARCHAR(50)   NOT NULL,
        Precio_Anterior       DECIMAL(10,2) NOT NULL,
        Stock_Anterior        INT           NOT NULL,
        Modelo_Anterior       VARCHAR(50)   NOT NULL,
        ID_Categoria_Anterior INT           NOT NULL,

        -- Valores NUEVOS (solo UPDATE)
        Codigo_SKU_Nuevo      INT           NULL,
        Talle_Nuevo           VARCHAR(10)   NULL,
        Color_Nuevo           VARCHAR(50)   NULL,
        Precio_Nuevo          DECIMAL(10,2) NULL,
        Stock_Nuevo           INT           NULL,
        Modelo_Nuevo          VARCHAR(50)   NULL,
        ID_Categoria_Nuevo    INT           NULL,

        CONSTRAINT PK_AUDITORIA_PRENDA PRIMARY KEY (ID_Auditoria),
        CONSTRAINT CHK_AUDITORIA_PRENDA_Operacion
            CHECK (Operacion IN ('UPDATE', 'DELETE'))
    );
END;
GO

IF OBJECT_ID('dbo.AUDITORIA_CLIENTE', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.AUDITORIA_CLIENTE
    (
        ID_Auditoria          INT IDENTITY(1,1) NOT NULL,
        Operacion             VARCHAR(6)    NOT NULL,   -- 'UPDATE' o 'DELETE'
        Fecha_Hora            DATETIME2(3)  NOT NULL,
        Usuario_Login         SYSNAME       NOT NULL,
        Usuario_BD            SYSNAME       NOT NULL,

        -- Valores ANTERIORES
        DNI_Anterior          INT           NOT NULL,
        Nombre_Anterior       VARCHAR(50)   NOT NULL,
        Apellido_Anterior     VARCHAR(50)   NOT NULL,
        Telefono_Anterior     VARCHAR(20)   NOT NULL,
        Calle_Anterior        VARCHAR(50)   NOT NULL,
        Altura_Anterior       INT           NOT NULL,
        Localidad_Anterior    VARCHAR(50)   NOT NULL,

        -- Valores NUEVOS (solo UPDATE)
        DNI_Nuevo             INT           NULL,
        Nombre_Nuevo          VARCHAR(50)   NULL,
        Apellido_Nuevo        VARCHAR(50)   NULL,
        Telefono_Nuevo        VARCHAR(20)   NULL,
        Calle_Nuevo           VARCHAR(50)   NULL,
        Altura_Nuevo          INT           NULL,
        Localidad_Nuevo       VARCHAR(50)   NULL,

        CONSTRAINT PK_AUDITORIA_CLIENTE PRIMARY KEY (ID_Auditoria),
        CONSTRAINT CHK_AUDITORIA_CLIENTE_Operacion
            CHECK (Operacion IN ('UPDATE', 'DELETE'))
    );
END;
GO

-- =====================================================================
-- 2. TRIGGERS DE AUDITORÍA SOBRE PRENDA
--
-- Notas de diseño:
--  * Son triggers AFTER: se ejecutan cuando el UPDATE/DELETE ya pasó
--    todas las restricciones (CHECK, FK). 
--  * Son SET-BASED (sin variables): un UPDATE/DELETE que afecta varias
--    filas dispara el trigger UNA sola vez y genera una fila de auditoría
--    por cada registro afectado.
--  * 'deleted'  = imagen de las filas ANTES del cambio.
--    'inserted' = imagen de las filas DESPUÉS del cambio.
--  * Se usa LEFT JOIN deleted -> inserted por la clave primaria para que
--    TODA fila modificada quede auditada, incluso si cambia la propia PK
--  * ORIGINAL_LOGIN() devuelve el login real de la conexión
--    USER_NAME() devuelve el usuario de la base de datos.
-- =====================================================================

CREATE OR ALTER TRIGGER dbo.trg_PRENDA_AuditoriaUpdate
ON dbo.PRENDA
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO dbo.AUDITORIA_PRENDA
        (Operacion, Fecha_Hora, Usuario_Login, Usuario_BD,
         Codigo_SKU_Anterior, Talle_Anterior, Color_Anterior, Precio_Anterior,
         Stock_Anterior, Modelo_Anterior, ID_Categoria_Anterior,
         Codigo_SKU_Nuevo, Talle_Nuevo, Color_Nuevo, Precio_Nuevo,
         Stock_Nuevo, Modelo_Nuevo, ID_Categoria_Nuevo)
    SELECT
        'UPDATE', SYSDATETIME(), ORIGINAL_LOGIN(), USER_NAME(),
        d.Codigo_SKU, d.Talle, d.Color, d.Precio_Actual,
        d.Stock, d.Modelo, d.ID_Categoria,
        i.Codigo_SKU, i.Talle, i.Color, i.Precio_Actual,
        i.Stock, i.Modelo, i.ID_Categoria
    FROM deleted AS d
    LEFT JOIN inserted AS i
           ON i.Codigo_SKU = d.Codigo_SKU;
END;
GO

CREATE OR ALTER TRIGGER dbo.trg_PRENDA_AuditoriaDelete
ON dbo.PRENDA
AFTER DELETE
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO dbo.AUDITORIA_PRENDA
        (Operacion, Fecha_Hora, Usuario_Login, Usuario_BD,
         Codigo_SKU_Anterior, Talle_Anterior, Color_Anterior, Precio_Anterior,
         Stock_Anterior, Modelo_Anterior, ID_Categoria_Anterior)
    SELECT
        'DELETE', SYSDATETIME(), ORIGINAL_LOGIN(), USER_NAME(),
        d.Codigo_SKU, d.Talle, d.Color, d.Precio_Actual,
        d.Stock, d.Modelo, d.ID_Categoria
    FROM deleted AS d;
END;
GO

-- =====================================================================
-- 3. TRIGGERS DE AUDITORÍA SOBRE CLIENTE
-- =====================================================================

CREATE OR ALTER TRIGGER dbo.trg_CLIENTE_AuditoriaUpdate
ON dbo.CLIENTE
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO dbo.AUDITORIA_CLIENTE
        (Operacion, Fecha_Hora, Usuario_Login, Usuario_BD,
         DNI_Anterior, Nombre_Anterior, Apellido_Anterior, Telefono_Anterior,
         Calle_Anterior, Altura_Anterior, Localidad_Anterior,
         DNI_Nuevo, Nombre_Nuevo, Apellido_Nuevo, Telefono_Nuevo,
         Calle_Nuevo, Altura_Nuevo, Localidad_Nuevo)
    SELECT
        'UPDATE', SYSDATETIME(), ORIGINAL_LOGIN(), USER_NAME(),
        d.DNI, d.Nombre, d.Apellido, d.Telefono,
        d.Calle, d.Altura, d.Localidad,
        i.DNI, i.Nombre, i.Apellido, i.Telefono,
        i.Calle, i.Altura, i.Localidad
    FROM deleted AS d
    LEFT JOIN inserted AS i
           ON i.DNI = d.DNI;
END;
GO

CREATE OR ALTER TRIGGER dbo.trg_CLIENTE_AuditoriaDelete
ON dbo.CLIENTE
AFTER DELETE
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO dbo.AUDITORIA_CLIENTE
        (Operacion, Fecha_Hora, Usuario_Login, Usuario_BD,
         DNI_Anterior, Nombre_Anterior, Apellido_Anterior, Telefono_Anterior,
         Calle_Anterior, Altura_Anterior, Localidad_Anterior)
    SELECT
        'DELETE', SYSDATETIME(), ORIGINAL_LOGIN(), USER_NAME(),
        d.DNI, d.Nombre, d.Apellido, d.Telefono,
        d.Calle, d.Altura, d.Localidad
    FROM deleted AS d;
END;
GO

-- =====================================================================
-- 4. TRIGGER QUE BLOQUEA EL DELETE SOBRE VENTA
--
-- Regla de negocio: un comprobante de venta es un registro comercial que
-- no debe borrarse, porque arrastraría su detalle (CONTIENE) y sus pagos
-- (ABONA_CON) por el ON DELETE CASCADE definido en el modelo.
--
-- Es INSTEAD OF: reemplaza al DELETE, por lo que la fila nunca se borra.
-- SQL Server NO permite INSTEAD OF DELETE en tablas que tengan una FK con
-- ON DELETE CASCADE definida en ellas (CONTIENE y ABONA_CON). VENTA sí lo
-- permite: su única FK (hacia CLIENTE) es ON DELETE NO ACTION.
--
-- La condición IF EXISTS evita que un DELETE que no afecta ninguna fila
-- (por ejemplo WHERE 1 = 0) genere un error innecesario.
-- =====================================================================

CREATE OR ALTER TRIGGER dbo.trg_VENTA_BloquearDelete
ON dbo.VENTA
INSTEAD OF DELETE
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (SELECT 1 FROM deleted)
    BEGIN
        THROW 50001, N'Operación no permitida: los comprobantes de venta no pueden eliminarse.', 1;
    END;
END;
GO

-- =====================================================================
-- 5. VERIFICACIÓN: los 5 triggers deben aparecer habilitados
--    (is_disabled = 0). Solo VENTA debe figurar como INSTEAD OF.
-- =====================================================================

SELECT
    t.name                   AS Trigger_Nombre,
    OBJECT_NAME(t.parent_id) AS Tabla,
    CASE WHEN t.is_instead_of_trigger = 1 THEN 'INSTEAD OF' ELSE 'AFTER' END AS Tipo,
    t.is_disabled            AS Deshabilitado
FROM sys.triggers AS t
WHERE t.parent_class = 1
  AND OBJECT_NAME(t.parent_id) IN ('PRENDA', 'CLIENTE', 'VENTA')
ORDER BY Tabla, Trigger_Nombre;
GO


-- #####################################################################
-- PARTE 2 - DEMOSTRACIÓN
-- #####################################################################

-- =====================================================================
-- Requiere (en este orden):
--   1) sql/ddl/crear_bd.sql
--   2) sql/dml/datos_prueba.sql        (se usan PRENDA 1001/1002, CLIENTE
--                                       30111222 y VENTA 8 de esos datos)
--   3) PARTE 1 de este archivo         (crea tablas y triggers)
-- =====================================================================

USE PROYECTO;
GO
SET NOCOUNT ON;
GO

-- (Opcional) Vaciar las auditorías para empezar la demostración limpia.
-- TRUNCATE TABLE dbo.AUDITORIA_PRENDA;
-- TRUNCATE TABLE dbo.AUDITORIA_CLIENTE;
-- GO

-- =====================================================================
-- PRUEBA 1 - UPDATE de una fila en PRENDA (precio y stock)
-- Esperado: 1 fila nueva en AUDITORIA_PRENDA con Operacion = 'UPDATE',
--   SKU 1001, Precio 15000.00 -> 18000.00, Stock 20 -> 18,
--   más fecha/hora y usuario.
-- =====================================================================
PRINT '--- PRUEBA 1: UPDATE de una prenda ---';

UPDATE dbo.PRENDA
SET Precio_Actual = 18000.00,
    Stock         = 18
WHERE Codigo_SKU = 1001;

SELECT ID_Auditoria, Operacion, Fecha_Hora, Usuario_Login, Usuario_BD,
       Codigo_SKU_Anterior AS SKU,
       Precio_Anterior, Precio_Nuevo, Stock_Anterior, Stock_Nuevo
FROM dbo.AUDITORIA_PRENDA
ORDER BY ID_Auditoria;
GO

-- =====================================================================
-- PRUEBA 2 - UPDATE de VARIAS filas con una sola sentencia
-- Esperado: 2 filas nuevas (SKU 1001 y 1002, categoría Remeras).
--   1001: 18000.00 -> 19000.00 | 1002: 15000.00 -> 16000.00
--   Demuestra que el trigger procesa todas las filas afectadas.
-- =====================================================================
PRINT '--- PRUEBA 2: UPDATE de varias prendas en una sola sentencia ---';

UPDATE dbo.PRENDA
SET Precio_Actual = Precio_Actual + 1000.00
WHERE ID_Categoria = 1;

SELECT ID_Auditoria, Operacion, Fecha_Hora, Usuario_Login,
       Codigo_SKU_Anterior AS SKU, Precio_Anterior, Precio_Nuevo
FROM dbo.AUDITORIA_PRENDA
ORDER BY ID_Auditoria;
GO

-- Reversión a los valores originales (también queda auditada: 2 filas más,
-- una por cada UPDATE; en total la tabla acumula 5 filas hasta acá)
UPDATE dbo.PRENDA SET Precio_Actual = 15000.00, Stock = 20 WHERE Codigo_SKU = 1001;
UPDATE dbo.PRENDA SET Precio_Actual = 15000.00             WHERE Codigo_SKU = 1002;
GO

-- =====================================================================
-- PRUEBA 3 - UPDATE en CLIENTE (teléfono y calle)
-- Esperado: 1 fila en AUDITORIA_CLIENTE, DNI 30111222,
--   Telefono '3794111111' -> '3794999999', Calle 'Junin' -> 'Salta'.
-- =====================================================================
PRINT '--- PRUEBA 3: UPDATE de un cliente ---';

UPDATE dbo.CLIENTE
SET Telefono = '3794999999',
    Calle    = 'Salta'
WHERE DNI = 30111222;

SELECT ID_Auditoria, Operacion, Fecha_Hora, Usuario_Login,
       DNI_Anterior AS DNI,
       Telefono_Anterior, Telefono_Nuevo, Calle_Anterior, Calle_Nuevo
FROM dbo.AUDITORIA_CLIENTE
ORDER BY ID_Auditoria;
GO

-- Reversión a los valores originales (queda auditada)
UPDATE dbo.CLIENTE
SET Telefono = '3794111111',
    Calle    = 'Junin'
WHERE DNI = 30111222;
GO

-- =====================================================================
-- PRUEBA 4 - DELETE en PRENDA (se crea una prenda de prueba sin ventas)
-- Esperado: 1 fila con Operacion = 'DELETE' que conserva todos los
--   valores que tenía la prenda 9999 antes de borrarse.
--   Las columnas *_Nuevo quedan en NULL.
-- El INSERT no se audita: solo se auditan UPDATE y DELETE.
-- =====================================================================
PRINT '--- PRUEBA 4: DELETE de una prenda ---';

INSERT INTO dbo.PRENDA (Codigo_SKU, Talle, Color, Precio_Actual, Stock, Modelo, ID_Categoria)
VALUES (9999, 'M', 'Rojo', 1000.00, 1, 'Prenda de prueba', 1);

DELETE FROM dbo.PRENDA WHERE Codigo_SKU = 9999;

SELECT ID_Auditoria, Operacion, Fecha_Hora, Usuario_Login,
       Codigo_SKU_Anterior AS SKU, Modelo_Anterior, Color_Anterior,
       Precio_Anterior, Stock_Anterior, Precio_Nuevo
FROM dbo.AUDITORIA_PRENDA
WHERE Operacion = 'DELETE'
ORDER BY ID_Auditoria;
GO

-- =====================================================================
-- PRUEBA 5 - DELETE en CLIENTE (cliente de prueba sin ventas)
-- Esperado: 1 fila con Operacion = 'DELETE' y todos los datos del
--   cliente 99999999 tal como estaban antes de borrarse.
-- =====================================================================
PRINT '--- PRUEBA 5: DELETE de un cliente ---';

INSERT INTO dbo.CLIENTE (DNI, Nombre, Apellido, Telefono, Calle, Altura, Localidad)
VALUES (99999999, 'Cliente', 'Prueba', '3794000000', 'Calle Falsa', 123, 'Corrientes');

DELETE FROM dbo.CLIENTE WHERE DNI = 99999999;

SELECT ID_Auditoria, Operacion, Fecha_Hora, Usuario_Login,
       DNI_Anterior, Nombre_Anterior, Apellido_Anterior,
       Telefono_Anterior, Localidad_Anterior
FROM dbo.AUDITORIA_CLIENTE
WHERE Operacion = 'DELETE'
ORDER BY ID_Auditoria;
GO

-- =====================================================================
-- PRUEBA 6 - DELETE rechazado por la FK (la restricción actúa primero)
-- La prenda 1001 figura en comprobantes de venta (CONTIENE, NO ACTION).
-- Esperado: error 547 (conflicto con FOREIGN KEY) y CERO filas de
--   auditoría para ese intento, porque el borrado nunca ocurrió.
-- =====================================================================
PRINT '--- PRUEBA 6: DELETE de una prenda vendida (rechazado por FK) ---';

BEGIN TRY
    DELETE FROM dbo.PRENDA WHERE Codigo_SKU = 1001;
    PRINT 'FALLO: el DELETE no debería haberse ejecutado.';
END TRY
BEGIN CATCH
    PRINT 'Error ' + CAST(ERROR_NUMBER() AS VARCHAR(10)) + ': ' + ERROR_MESSAGE();
END CATCH;

SELECT COUNT(*) AS Auditorias_DELETE_SKU_1001   -- esperado: 0
FROM dbo.AUDITORIA_PRENDA
WHERE Operacion = 'DELETE' AND Codigo_SKU_Anterior = 1001;
GO

-- =====================================================================
-- PRUEBA 7 - Trigger que BLOQUEA el DELETE sobre VENTA
-- Esperado:
--   * Error 50001: 'Operación no permitida: los comprobantes de venta
--     no pueden eliminarse.'
--   * La venta sigue existiendo y su detalle (CONTIENE) y pagos
--     (ABONA_CON) siguen intactos: el ON DELETE CASCADE no se dispara.
--   * Un DELETE que no afecta filas no genera error.
-- =====================================================================
PRINT '--- PRUEBA 7: intento de DELETE sobre VENTA ---';

DECLARE @ventas_antes   INT = (SELECT COUNT(*) FROM dbo.VENTA);
DECLARE @detalle_antes  INT = (SELECT COUNT(*) FROM dbo.CONTIENE);
DECLARE @pagos_antes    INT = (SELECT COUNT(*) FROM dbo.ABONA_CON);

BEGIN TRY
    DELETE FROM dbo.VENTA WHERE Nro_Comprobante = 8;
    PRINT 'FALLO: el DELETE no debería haberse ejecutado.';
END TRY
BEGIN CATCH
    PRINT 'Error ' + CAST(ERROR_NUMBER() AS VARCHAR(10)) + ': ' + ERROR_MESSAGE();
END CATCH;

SELECT
    @ventas_antes  AS Ventas_Antes,   (SELECT COUNT(*) FROM dbo.VENTA)    AS Ventas_Despues,
    @detalle_antes AS Detalle_Antes,  (SELECT COUNT(*) FROM dbo.CONTIENE) AS Detalle_Despues,
    @pagos_antes   AS Pagos_Antes,    (SELECT COUNT(*) FROM dbo.ABONA_CON) AS Pagos_Despues;

IF  @ventas_antes  = (SELECT COUNT(*) FROM dbo.VENTA)
AND @detalle_antes = (SELECT COUNT(*) FROM dbo.CONTIENE)
AND @pagos_antes   = (SELECT COUNT(*) FROM dbo.ABONA_CON)
    PRINT 'OK: el trigger bloqueó el DELETE y no se perdió ningún dato.';
ELSE
    PRINT 'FALLO: se modificaron datos.';

-- DELETE que no afecta ninguna fila: no debe dar error
DELETE FROM dbo.VENTA WHERE Nro_Comprobante = -1;
PRINT 'OK: un DELETE sin filas afectadas no genera error.';
GO

-- =====================================================================
-- CONSULTAS DE AUDITORÍA (responden las preguntas de la guía)
-- =====================================================================

-- ¿Quién modificó un precio, cuándo, y qué valor tenía antes?
SELECT Fecha_Hora, Usuario_Login, Codigo_SKU_Anterior AS SKU,
       Modelo_Anterior, Precio_Anterior, Precio_Nuevo
FROM dbo.AUDITORIA_PRENDA
WHERE Operacion = 'UPDATE'
  AND Precio_Anterior <> Precio_Nuevo
ORDER BY Fecha_Hora;

-- ¿Qué prendas se eliminaron y quién las eliminó?
SELECT Fecha_Hora, Usuario_Login, Codigo_SKU_Anterior AS SKU,
       Modelo_Anterior, Precio_Anterior, Stock_Anterior
FROM dbo.AUDITORIA_PRENDA
WHERE Operacion = 'DELETE'
ORDER BY Fecha_Hora;

-- Historial completo de ambas tablas de auditoría
SELECT * FROM dbo.AUDITORIA_PRENDA  ORDER BY ID_Auditoria;
SELECT * FROM dbo.AUDITORIA_CLIENTE ORDER BY ID_Auditoria;
GO

-- Estado final de los datos de prueba (deben coincidir con datos_prueba.sql)
SELECT Codigo_SKU, Modelo, Precio_Actual, Stock
FROM dbo.PRENDA WHERE Codigo_SKU IN (1001, 1002);

SELECT DNI, Nombre, Telefono, Calle
FROM dbo.CLIENTE WHERE DNI = 30111222;
GO
