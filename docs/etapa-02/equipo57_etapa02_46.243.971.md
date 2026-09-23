## Contribución Individual -- Etapa 2
**Equipo:57**
**Integrante:Alessandro Sebastián Rivero**
**Fecha: 2026-09-23**
## Aporte Realizado:
**Analisis y Aplicación  de la Primera Forma Normal (`1FN`) sobre el modelo relacional del sistema "Estilo Urbano"**
•Verificación de la atomicidad de todos los atributos del modelo relacional.
•Desglose el atributo compuesto `Dirección` del modelo conceptual en 3 columnas atómicas en la tabla `CLIENTE`: `Calle`, `Altura` y `Localidad`.
•Validación de que cada entidad  posea una Clave Primaria (`PK`).
•Eliminación de grupos repetitivos mediante la revisión de las tablas intermedias `CONTIENE` y `ABONA_CON` con claves compuestas.
•Redacción a la sección correspondiente a la `1FN` en el archivo **normalización.md**
•Redacción a la sección correspondiente al archivo **decisiones_diseno.md**.
## Problemas o  dificultades identificadas:
•**Identificar** cómo representar la dirección del cliente sin romper el principio de atomicidad  de la `1FN`.
•**Comprender** cómo evitar los grupos repetitivos cuando una misma venta contiene varias prendas o se paga con mas de un metodo.
## Soluciones:
•**Se Propuso** transformar el atributo compuesto `Dirección` en tres atributos atómicos independientes (`Calle`, `AlturaA`, `Localidad`) en la tabla `CLIENTE`.
•**Se Valido** el uso de clave primarias compuestas en las tablas intermedias.
## Evidencia:

https://github.com/josefina-belen/proyecto-bd1-equipo_57/blob/main/docs/etapa-02/Normalizacion.md

https://github.com/josefina-belen/proyecto-bd1-equipo_57/blob/main/docs/etapa-02/Decisiones-diseno.md
