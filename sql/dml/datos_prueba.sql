-- 2) INSERCIÓN DE DATOS
USE PROYECTO;
GO

-- 1. TABLAS SIN DEPENDENCIAS (Se cargan primero)

INSERT INTO METODO_PAGO (Descripcion) VALUES 
('Efectivo'),
('Tarjeta de Crédito Visa'),
('Tarjeta de Crédito Mastercard'),
('Tarjeta de Débito Visa'),
('Tarjeta de Débito Maestro'),
('Mercado Pago'),
('Transferencia Bancaria'),
('MODO');

INSERT INTO CATEGORIA (Nombre) VALUES 
('Remeras'),
('Pantalones'),
('Buzos'),
('Camperas'),
('Zapatillas'),
('Accesorios'),
('Shorts'),
('Vestidos');

-- Carga de Clientes 
INSERT INTO CLIENTE (DNI, Nombre, Apellido, Telefono, Calle, Altura, Localidad) VALUES
(30111222, 'Juan', 'Perez', '3794111111', 'Junin', 1200, 'Corrientes'),
(31222333, 'Maria', 'Gomez', '3794222222', 'San Martin', 850, 'Corrientes'),
(32333444, 'Carlos', 'Lopez', '3624333333', 'Av. Alberdi', 150, 'Resistencia'),
(33444555, 'Ana', 'Martinez', '3794444444', 'Pellegrini', 900, 'Corrientes'),
(34555666, 'Luis', 'Fernandez', '3777555555', 'Colon', 340, 'Goya'),
(35666777, 'Laura', 'Diaz', '3794666666', 'Irigoyen', 1500, 'Corrientes'),
(36777888, 'Diego', 'Romero', '3794777777', 'Tucuman', 600, 'Corrientes'),
(37888999, 'Sofia', 'Sosa', '3624888888', 'Guemes', 120, 'Resistencia');


-- 2. TABLAS CON DEPENDENCIAS SIMPLES

-- Carga de Prendas (Depende de Categoría. El ID_Categoria del 1 al 8 ya existe)
INSERT INTO PRENDA (Codigo_SKU, Talle, Color, Precio_Actual, Stock, Modelo, ID_Categoria) VALUES
(1001, 'M', 'Blanco', 15000.00, 20, 'Remera Basic', 1),
(1002, 'L', 'Negro', 15000.00, 15, 'Remera Basic', 1),
(1003, '42', 'Azul', 45000.00, 10, 'Jean Classic', 2),
(1004, 'XL', 'Gris', 35000.00, 5, 'Buzo Canguro', 3),
(1005, 'S', 'Verde', 60000.00, 8, 'Campera Puffer', 4),
(1006, 'M', 'Rojo', 18000.00, 12, 'Short Deportivo', 7),
(1007, 'U', 'Negro', 5000.00, 30, 'Gorra Logo', 6),
(1008, 'L', 'Floreado', 25000.00, 7, 'Vestido Verano', 8);

-- Carga de Ventas (Depende de Cliente. Usamos los DNI creados antes)
INSERT INTO VENTA (Fecha, DNI) VALUES
('2026-09-01 10:30:00', 30111222),
('2026-09-05 15:45:00', 31222333),
('2026-09-10 09:15:00', 32333444),
('2026-09-12 18:20:00', 33444555),
('2026-09-15 11:10:00', 34555666),
('2026-09-20 16:00:00', 35666777),
('2026-09-22 13:40:00', 36777888),
('2026-09-25 17:30:00', 37888999);


-- 3. TABLAS INTERMEDIAS 

-- Carga de Detalles de Venta (CONTIENE)
INSERT INTO CONTIENE (Nro_Comprobante, Codigo_SKU, Precio_Historico, Cantidad) VALUES
(1, 1001, 15000.00, 1), 
(2, 1003, 45000.00, 1), 
(3, 1004, 35000.00, 1), 
(4, 1005, 60000.00, 1), 
(5, 1006, 18000.00, 1), 
(6, 1007, 5000.00, 1),  
(7, 1008, 25000.00, 1), 
(8, 1001, 15000.00, 2); 

-- Carga de Pagos (ABONA_CON)
-- Relaciona el método de pago con el comprobante y el monto final abonado.
INSERT INTO ABONA_CON (ID_Metodo, Nro_Comprobante, Monto_Abonado) VALUES
(1, 1, 15000.00), -- Efectivo
(2, 2, 45000.00), -- Tarjeta Visa
(6, 3, 35000.00), -- Mercado Pago
(4, 4, 60000.00), -- Debito Visa
(1, 5, 18000.00), -- Efectivo
(7, 6, 5000.00),  -- Transferencia
(6, 7, 25000.00), -- Mercado Pago
(3, 8, 30000.00); -- Tarjeta Master (Monto coincide con las 2 remeras)

SELECT * FROM METODO_PAGO;
SELECT * FROM CLIENTE;
SELECT * FROM VENTA;
SELECT * FROM CATEGORIA;
SELECT * FROM PRENDA;
SELECT * FROM CONTIENE;
SELECT * FROM ABONA_CON;
