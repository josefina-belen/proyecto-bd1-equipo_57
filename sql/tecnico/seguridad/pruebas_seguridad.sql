-- ==============================================================================
-- PARTE 4: PRUEBAS DE PERMISOS DE USUARIOS
-- ==============================================================================
USE PROYECTO;
GO

-----------------------------------------------------------
-- A. Caso válido: Administrador insertando directamente
-----------------------------------------------------------
EXECUTE AS USER = 'usr_admin';
INSERT INTO dbo.CATEGORIA (Nombre) VALUES ('Accesorios Urbanos');
REVERT;
GO

SELECT * FROM dbo.CATEGORIA WHERE Nombre = 'Accesorios Urbanos';
GO

-----------------------------------------------------------
-- B. Caso inválido: Lector intentando insertar directamente
-----------------------------------------------------------
EXECUTE AS USER = 'usr_lector';
INSERT INTO dbo.CATEGORIA (Nombre) VALUES ('Calzado Urbano');
REVERT;
GO

-----------------------------------------------------------
-- C. Caso válido: Lector utilizando el procedimiento almacenado
-----------------------------------------------------------
EXECUTE AS USER = 'usr_lector';
EXEC dbo.sp_InsertarCategoria @Nombre = 'Calzado Urbano';
REVERT;
GO

SELECT * FROM dbo.CATEGORIA WHERE Nombre = 'Calzado Urbano';
GO

-----------------------------------------------------------
-- D. Probar el usuario que pertenece al rol (Depósito)
-----------------------------------------------------------
EXECUTE AS USER = 'usr_con_rol';
SELECT TOP 5 * FROM dbo.PRENDA;
REVERT;
GO

-----------------------------------------------------------
-- E. Probar el usuario que NO pertenece al rol (Externo)
-----------------------------------------------------------
EXECUTE AS USER = 'usr_sin_rol';
SELECT TOP 5 * FROM dbo.PRENDA;
REVERT;
GO


-- ==============================================================================
-- VERIFICACIÓN FINAL GENERAL
-- ==============================================================================

-- 1. Verificar usuarios y roles:
SELECT
    usuario.name AS Usuario,
    usuario.type_desc AS Tipo,
    rol.name AS Rol
FROM sys.database_role_members AS membresia
INNER JOIN sys.database_principals AS usuario
    ON membresia.member_principal_id = usuario.principal_id
INNER JOIN sys.database_principals AS rol
    ON membresia.role_principal_id = rol.principal_id
WHERE usuario.name IN ('usr_admin', 'usr_lector', 'usr_con_rol', 'usr_sin_rol')
ORDER BY usuario.name;
GO

-- 2. Verificar los permisos otorgados: 
SELECT
    USER_NAME(perm.grantee_principal_id) AS UsuarioORol,
    perm.permission_name AS Permiso,
    perm.state_desc AS Estado,
    OBJECT_NAME(perm.major_id) AS Objeto
FROM sys.database_permissions AS perm
WHERE USER_NAME(perm.grantee_principal_id) IN ('usr_lector', 'Rol_Lector_Catalogo')
ORDER BY UsuarioORol, Objeto;
GO

-- 3. Verificar que existen los usuarios y el procedimiento: 
SELECT name AS Usuario
FROM sys.database_principals
WHERE name IN ('usr_admin', 'usr_lector', 'usr_con_rol', 'usr_sin_rol');
GO

SELECT name AS Procedimiento
FROM sys.procedures
WHERE name = 'sp_InsertarCategoria';
GO

-- 4. Verificar los inicios de sesión del servidor: 
USE master;
GO
SELECT name AS Login
FROM sys.server_principals
WHERE name IN ('login_admin', 'login_lector', 'login_empleado_deposito', 'login_empleado_externo');
GO
