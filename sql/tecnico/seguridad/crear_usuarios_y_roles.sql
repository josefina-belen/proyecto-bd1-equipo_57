-- ==============================================================================
-- PARTE 1: CREAR EL PROCEDIMIENTO ALMACENADO
-- ==============================================================================
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
SELECT name FROM sys.procedures WHERE name = 'sp_InsertarCategoria';
GO

-- ==============================================================================
-- PARTE 2: CREAR LOS LOGINS Y USUARIOS
-- ==============================================================================
USE master;
GO

-- 1. Crear los logins del servidor
CREATE LOGIN login_admin WITH PASSWORD = 'AdministradorUrbano1!';
CREATE LOGIN login_lector WITH PASSWORD = 'Ventas_Urbano2!';
CREATE LOGIN login_empleado_deposito WITH PASSWORD = 'Deposito_Urbano1!';
CREATE LOGIN login_empleado_externo WITH PASSWORD = 'Externo_Urbano1!';
GO

-- 2. Crear los usuarios dentro de PROYECTO
USE PROYECTO;
GO

CREATE USER usr_admin FOR LOGIN login_admin;
CREATE USER usr_lector FOR LOGIN login_lector;
CREATE USER usr_con_rol FOR LOGIN login_empleado_deposito;
CREATE USER usr_sin_rol FOR LOGIN login_empleado_externo;
GO

-- 3. Comprobar los usuarios creados
SELECT name, type_desc 
FROM sys.database_principals 
WHERE name IN ('usr_admin','usr_lector','usr_con_rol','usr_sin_rol');
GO

-- ==============================================================================
-- PARTE 3: CREAR LOS ROLES Y ASIGNAR PERMISOS
-- ==============================================================================
USE PROYECTO;
GO

-- 1. Asignar rol de administrador
ALTER ROLE db_owner ADD MEMBER usr_admin;

-- 2. Asignar rol de lector
ALTER ROLE db_datareader ADD MEMBER usr_lector;

-- 3. Crear el rol personalizado
CREATE ROLE Rol_Lector_Catalogo;

-- 4. Dar permiso de lectura sobre PRENDA
GRANT SELECT ON dbo.PRENDA TO Rol_Lector_Catalogo;

-- 5. Incorporar al empleado de depósito al rol
ALTER ROLE Rol_Lector_Catalogo ADD MEMBER usr_con_rol;

-- 6. Permitir al lector ejecutar el procedimiento
GRANT EXECUTE ON OBJECT::dbo.sp_InsertarCategoria TO usr_lector;
GO

-- 7. Consultar los roles asignados
SELECT 
    usuario.name AS Usuario, 
    rol.name AS Rol 
FROM sys.database_role_members AS miembros
INNER JOIN sys.database_principals AS rol ON miembros.role_principal_id = rol.principal_id
INNER JOIN sys.database_principals AS usuario ON miembros.member_principal_id = usuario.principal_id
WHERE usuario.name IN ('usr_admin','usr_lector','usr_con_rol','usr_sin_rol');
GO
