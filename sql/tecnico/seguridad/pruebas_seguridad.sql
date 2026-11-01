USE PROYECTO;
GO

-- ==============================================================================
-- CASO 1: INSERCIÓN DE DATOS (PERMISOS DE USUARIO)
-- ==============================================================================

-----------------------------------------------------------
-- A) Caso Válido 1: Administrador insertando directamente
-- FOTO A SACAR: Mensaje "(1 row affected)" en la pestaña Mensajes
-----------------------------------------------------------
EXECUTE AS LOGIN = 'login_urbano_admin';
GO

INSERT INTO dbo.CATEGORIA (Nombre) VALUES ('Buzos');
GO

REVERT;
GO

-----------------------------------------------------------
-- B) Caso Inválido: Vendedor intentando hacer INSERT directo
-- FOTO A SACAR: Texto rojo (Error 229 denegado) en la pestaña Mensajes
-----------------------------------------------------------
EXECUTE AS LOGIN = 'login_urbano_ventas';
GO

INSERT INTO dbo.CATEGORIA (Nombre) VALUES ('Camperas');
GO

REVERT; 
GO

-----------------------------------------------------------
-- C) Caso Válido 2: Vendedor insertando mediante Procedimiento Almacenado
-- FOTO A SACAR: Mensaje "(1 row affected)" en la pestaña Mensajes
-----------------------------------------------------------
EXECUTE AS LOGIN = 'login_urbano_ventas';
GO

EXEC dbo.sp_InsertarCategoria @Nombre = 'Camperas';
GO

REVERT;
GO


-- ==============================================================================
-- CASO 2: LECTURA DE CATÁLOGO (PERMISOS POR ROL)
-- ==============================================================================

-----------------------------------------------------------
-- D) Caso Válido: Empleado de depósito leyendo PRENDA
-- FOTO A SACAR: La tablita con los datos en la pestaña Resultados (Results)
-----------------------------------------------------------
EXECUTE AS LOGIN = 'login_urbano_deposito';
GO

SELECT TOP 5 * FROM dbo.PRENDA;
GO

REVERT;
GO

-----------------------------------------------------------
-- E) Caso Inválido: Empleado de otra área intentando leer PRENDA
-- FOTO A SACAR: Texto rojo (Error 229 denegado) en la pestaña Mensajes
-----------------------------------------------------------
EXECUTE AS LOGIN = 'login_urbano_externo';
GO

SELECT TOP 5 * FROM dbo.PRENDA;
GO

REVERT;
GO
