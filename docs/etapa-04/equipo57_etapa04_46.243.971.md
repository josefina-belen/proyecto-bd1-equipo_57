## Contribución Individual---Etapa 04

**Equipo:** 57 
**Integrante:** Alessandro Sebastián Rivero 
**Fecha:** 2026-10-17

## 1. Aporte Realizado:
Encargado de Realizar  en conjunto el archivo **comprobante-venta.md** con **Toledo Pablo**.
-Diseño y programación de la Consulta SQL analitica para la emisión de facturas y comprobantes de venta.

-Se Implemento la consolidación de datos entre  las entidades **VENTA**,**CLIENTE**,**CONTIENE** y **PRENDA** mediante combinaciones **INNER JOIN**.

-Incorporación de calculo del subtotal por ítem (**Cantidad * Precio_Historico**) y el total general de la factura mediante funciones de ventana ( **SUM () OVER ( PARTITION BY Nro_Comprobante**).

## 2.Decisiones en las que Participe:
Se penso y decidio realizar como calculariamos la plata ( Subtotales y total final a pagar)
usando las matemáticas de SQL para asegurar que se mezclen  los renglones en la lista con la ropa  que llevo el cliente.

## 3. Problemas o dificultades identificadas:
Tuvimos unos problemas  de sintaxis por algunos errores cometidos anteriormente en algunos comandos y nombres mal definidos.

## 4. Solución o Propuesta Realizada:
Para solucionar  se fue identificando  los mensajes de error que devolvía la consola del motor SQL. Tambien verificamos lo  realizado en el archivo DDL para corregir los nombres mal definidos  anteriomente que daban errores de sintaxis.




