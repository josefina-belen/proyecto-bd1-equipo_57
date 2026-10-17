USE PROYECTO;
GO

SELECT 
    V.Nro_Comprobante AS Nro_Factura,
    V.Fecha AS Fecha_Emision,
    C.Nombre + ' ' + C.Apellido AS Cliente,
    C.DNI,
    P.Modelo AS Producto,
    D.Precio_Historico AS Precio_Unitario,
    D.Cantidad,
    -- Calculamos el subtotal del renglón (Cantidad * Precio)
    (D.Cantidad * D.Precio_Historico) AS Subtotal_Renglon,
    
    -- Calculamos el total de la factura sumando todos sus renglones
    SUM(D.Cantidad * D.Precio_Historico) OVER (PARTITION BY V.Nro_Comprobante) AS Total_Factura

FROM VENTA V
INNER JOIN CLIENTE C ON V.DNI = C.DNI
INNER JOIN CONTIENE D ON V.Nro_Comprobante = D.Nro_Comprobante
INNER JOIN PRENDA P ON D.Codigo_SKU = P.Codigo_SKU

-- Filtramos para ver el detalle de una factura específica
WHERE V.Nro_Comprobante = 1;
