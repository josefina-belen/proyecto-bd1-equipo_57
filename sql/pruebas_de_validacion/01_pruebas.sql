-- Script de Pruebas de Validación - Estilo Urbano (Grupo 57)
USE PROYECTO;

-- 1. PRUEBAS DE RESTRICCIONES DE DOMINIO (CHECK y UNIQUE)

-- Bloqueo de Stock Negativo
-- Resultado esperado: Error 547 (Conflicto con la restricción CHECK 'CHK_PRENDA_Stock')
INSERT INTO PRENDA (Codigo_SKU, Talle, Color, Precio_Actual, Stock, Modelo, ID_Categoria) 
VALUES (9999, 'M', 'Blanco', 15000.00, -5, 'Remera Fallada', 1);

-- Bloqueo de Precios Inválidos ($0.00)
-- Resultado esperado: Error 547 (Conflicto con la restricción CHECK 'CHK_CONTIENE_Precio_Historico')
INSERT INTO CONTIENE (Nro_Comprobante, Codigo_SKU, Precio_Historico, Cantidad) 
VALUES (1, 1002, 0.00, 1);


-- Unicidad de Categorías (UNIQUE)
-- Resultado esperado: Error 2627 (Infracción de UNIQUE KEY, 'Remeras' ya existe)
INSERT INTO CATEGORIA (Nombre) VALUES ('Remeras');



-- 2. PRUEBAS DE INTEGRIDAD REFERENCIAL (FOREIGN KEY)


-- Bloqueo por Protección de Datos (ON DELETE NO ACTION)
-- Resultado esperado: Error 547 (Conflicto con la restricción REFERENCE 'FK_VENTA_DNI' porque el cliente ya tiene compras)
DELETE FROM CLIENTE WHERE DNI = 30111222;


-- Actualización en Cascada (ON UPDATE CASCADE)
-- Resultado esperado: Se actualiza 1 fila con éxito en PRENDA. 
-- El SELECT posterior debe mostrar el SKU 5001 reflejado automáticamente en la tabla CONTIENE.
UPDATE PRENDA 
SET Codigo_SKU = 5001 
WHERE Codigo_SKU = 1001;


-- Verificación de la cascada:
SELECT * FROM CONTIENE WHERE Codigo_SKU = 5001;


-- Eliminación en Cascada (ON DELETE CASCADE)
-- Resultado esperado: Eliminación exitosa en VENTA. 
-- Los SELECT posteriores deben devolver 0 filas al limpiar registros dependientes.
DELETE FROM VENTA WHERE Nro_Comprobante = 8;


-- Verificación de la limpieza automática en las tablas dependientes:
SELECT * FROM ABONA_CON WHERE Nro_Comprobante = 8;
SELECT * FROM CONTIENE WHERE Nro_Comprobante = 8;

