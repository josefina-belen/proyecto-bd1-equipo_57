USE PROYECTO;
GO

-- 0) Limpiamos los clientes de prueba antes de arrancar para que no tire error de DNI duplicado
DELETE FROM CLIENTE WHERE Dni IN (95111222, 98444555, 90222333, 91777888, 92999000, 93555666);

-- A) Lote de inserción con sentencias INSERT directas
INSERT INTO CLIENTE (Dni, Nombre, Apellido, Localidad, Telefono, Calle, Altura) VALUES (95111222, 'Carlos', 'Gomez', 1, '3794111111', 'San Martin', 100);
INSERT INTO CLIENTE (Dni, Nombre, Apellido, Localidad, Telefono, Calle, Altura) VALUES (98444555, 'Maria', 'Lopez', 1, '3794222222', 'Junin', 200);
INSERT INTO CLIENTE (Dni, Nombre, Apellido, Localidad, Telefono, Calle, Altura) VALUES (90222333, 'Sofia', 'Ramirez', 1, '3794333333', 'Pellegrini', 300);

-- B) Lote de inserción invocando al procedimiento almacenado
EXEC dbo.sp_InsertarCliente @Dni = 91777888, @Nombre = 'Ana', @Apellido = 'Martinez', @Localidad = 1, @Telefono = '3794444444', @Calle = 'Salta', @Altura = 400;
EXEC dbo.sp_InsertarCliente @Dni = 92999000, @Nombre = 'Luis', @Apellido = 'Fernandez', @Localidad = 1, @Telefono = '3794555555', @Calle = 'Tucuman', @Altura = 500;
EXEC dbo.sp_InsertarCliente @Dni = 93555666, @Nombre = 'Pedro', @Apellido = 'Sanchez', @Localidad = 1, @Telefono = '3794666666', @Calle = 'Mendoza', @Altura = 600;

-- C) Modificación (UPDATE) de registros invocando al procedimiento
EXEC dbo.sp_ModificarCliente @Dni = 91777888, @NuevoNombre = 'Ana Clara', @NuevoApellido = 'Martinez';

-- D) Eliminación (DELETE) de registros invocando al procedimiento
EXEC dbo.sp_BorrarCliente @Dni = 92999000;

-- E) Demostración del uso de las tres funciones almacenadas en una consulta
SELECT 
    Dni,
    dbo.fn_NombreCompleto(Nombre, Apellido) AS Cliente_Formateado,
    dbo.fn_CantidadComprasCliente(Dni) AS Cantidad_Compras,
    dbo.fn_TotalGastadoCliente(Dni) AS Total_Acumulado
FROM CLIENTE;
GO
