USE PROYECTO;
GO

-----------------------------------------------------------
-- 1. PERMISOS A NIVEL DE USUARIOS 
-----------------------------------------------------------
-- A. Creación de Logins con contraseñas personalizadas
CREATE LOGIN login_admin WITH PASSWORD = 'AdministradorUrbano1!';
CREATE LOGIN login_lector WITH PASSWORD = 'Ventas_Urbano2!';

-- B. Creación de Usuarios de Base de Datos
CREATE USER usr_admin FOR LOGIN login_admin;
CREATE USER usr_lector FOR LOGIN login_lector;

-- C. Asignación de Roles predefinidos
ALTER ROLE db_owner ADD MEMBER usr_admin;
ALTER ROLE db_datareader ADD MEMBER usr_lector;

-- D. Delegación de permisos
-- (Se asume que sp_InsertarCategoria ya fue creado previamente)
GRANT EXECUTE ON OBJECT::dbo.sp_InsertarCategoria TO usr_lector;
GO

-----------------------------------------------------------
-- 2. PERMISOS A NIVEL DE ROLES DEL DBMS
-----------------------------------------------------------
-- A. Creación de Logins y Usuarios para prueba de roles
CREATE LOGIN login_empleado_deposito WITH PASSWORD = 'Deposito_Urbano1!';
CREATE LOGIN login_empleado_externo WITH PASSWORD = 'Externo_Urbano1!';

CREATE USER usr_con_rol FOR LOGIN login_empleado_deposito;
CREATE USER usr_sin_rol FOR LOGIN login_empleado_externo;

-- B. Creación del Rol Personalizado
CREATE ROLE Rol_Lector_Catalogo;

-- C. Asignación de permisos restrictivos al Rol
GRANT SELECT ON dbo.PRENDA TO Rol_Lector_Catalogo;

-- D. Asignación del usuario al Rol
ALTER ROLE Rol_Lector_Catalogo ADD MEMBER usr_con_rol;
GO
