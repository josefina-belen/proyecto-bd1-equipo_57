# Prueba de Validación - **Estilo Urbano (Grupo 57)**

USE PROYECTO;

--1. RESTRICCIONES DE DOMINIO ( CHECK y UNIQUE)

-- Bloque de Stock Negativo
-- Resultado Esperado: Error 547 (Conflicto con la restricción CHECK 'CHK_PRENDA_Stock')
INSERT INTO PRENDA (Codigo_SKU, Talle, Color, Precio_Actual, Stock, Modelo, ID_Categoria)
VALUES (9999, 'M', 'Blanco', 1500.00, -5, 'Remera Fallada', 1);
