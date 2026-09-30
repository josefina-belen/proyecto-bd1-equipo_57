# Prueba de Validación - **Estilo Urbano (Grupo 57)**

USE PROYECTO;

--1. RESTRICCIONES DE DOMINIO ( CHECK y UNIQUE)

-- Bloqueo de Stock Negativo
-- Resultado Esperado: Error 547 (Conflicto con la restricción CHECK 'CHK_PRENDA_Stock')
INSERT INTO PRENDA (Codigo_SKU, Talle, Color, Precio_Actual, Stock, Modelo, ID_Categoria)
VALUES (9999, 'M', 'Blanco', 1500.00, -5, 'Remera Fallada', 1);

--Bloqueo de Precios Inválidos ($0.00)
-- Resultado Esperado: Error 547 (Conflicto con la restricción CHECK 'CHK_CONTIENE_Precio_Historico')
INSERT INTO CONTIENE (Nro_Comprobante, Codigo_SKU, Precio_Historico, Cantidad)
VALUED (1, 1002, 0.00, 1);

-- Unicidad de Categorias (UNIQUE)
-- Resultado Esperado: Error 2627 (Infracción de UNIQUE KEY, **'Remeras'** ya existe)
INSERT INTO CATEGORIA (Nombre) VALUES (**'Remeras'**);
