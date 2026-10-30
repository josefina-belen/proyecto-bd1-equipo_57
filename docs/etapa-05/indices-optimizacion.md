Etapa V – Optimización de consultas a través de índices 
Sistema: Estilo Urbano (tienda de ropa) · Motor: SQL Server Express · Base: PROYECTO 

1. Definición y objetivo 
Un índice es una estructura que SQL Server mantiene para localizar filas sin recorrer toda la tabla, igual que el índice de un libro. Sin índice, una consulta
con filtro debe leer todas las filas (Table Scan); con un índice adecuado puede ir directo a las filas buscadas (Index Seek). 
Tipos usados en este trabajo:Tipo DescripciónAgrupado (clustered) Define el orden físico de la tabla; solo uno por tabla. Las hojas contienen las filas completas.No agrupado (nonclustered) Estructura aparte con la clave y un puntero a la fila. Puede incluir columnas adicionales (INCLUDE).Con cobertura (covering) Índice no agrupado que contiene todas las columnas que pide la consulta, por lo que no necesita acceder a la tabla. 
Objetivo: medir cuánto mejora el rendimiento de las consultas del sistema de ventas (ventas por período, historial de un cliente) al agregar distintos
índices sobre una tabla con 1.000.000 de registros. 

2. Ventajas y aplicaciones 
Menos lecturas de páginas y menores tiempos de respuesta en filtros por fecha, cliente o código.
Escalabilidad: el costo de una búsqueda crece mucho más lento que el tamaño de la tabla.
Permiten acelerar informes, comprobantes y consultas de historial. 
Costos: ocupan espacio en disco y hacen más lentos los INSERT, UPDATE y DELETE, porque cada índice debe mantenerse actualizado. 

3. Implementación en SQL Server Express 
CREATE CLUSTERED INDEX, CREATE NONCLUSTERED INDEX ... INCLUDE (...), DROP INDEX.
SET STATISTICS IO ON y SET STATISTICS TIME ON para medir lecturas lógicas, CPU y tiempo total.
Plan de ejecución real (Ctrl+M en SSMS) para identificar el operador principal.
CHECKPOINT + DBCC DROPCLEANBUFFERS antes de cada medición para partir de caché fría (solo en entornos de prueba). 

4. Caso aplicado al sistema de ventas 
El esquema real tiene pocas filas, así que se creó la tabla de pruebas VENTA_HISTORICA, que replica el modelo de VENTA / CONTIENE y es independiente
de las tablas reales:Columna Tipo Equivale aNro_Comprobante BIGINT IDENTITY VENTA.Nro_ComprobanteFecha DATE VENTA.FechaDNI INT VENTA.DNI (cliente)Total DECIMAL(12,2) total de la venta (suma de CONTIENE) 
Se cargan 1.000.000 de filas (fechas 2020–2024, 50.000 DNI distintos). Consultas del negocio evaluadas: 
A: ventas de un trimestre (Fecha BETWEEN '2023-01-01' AND '2023-03-31').
B: solo Fecha y Total del mismo trimestre (consulta que un índice puede cubrir).
C: historial de un cliente (DNI = 30012345). 

5. Scripts de demostración y resultados 
Scripts: sql/tecnico/indices/01_crear_y_cargar_venta_historica.sql y 02_pruebas_indices.sql. Cada consulta se ejecutó 3 veces y
se tomó el promedio. Los valores dependen del hardware. 
5.1 Consulta por rango de fechasEscenario Consulta CPU (ms) Tiempo total (ms) Lecturas lógicas Operación principal1. Sin índice A completar completar completar Table Scan2. Índice agrupado sobre Fecha A completar completar completar Clustered Index Seek3. Índice con cobertura (Fecha) INCLUDE (Total) B completar completar completar Index Seek3b. Mismo índice, consulta que no cubre A completar completar completar completar (Scan o Seek + Lookup) 
 Pegar capturas de los planes de ejecución y de la pestaña Mensajes de cada escenario. 

5.2 Historial de un clienteEscenario CPU (ms) Tiempo total (ms) Lecturas lógicas Operación principalSin índice por DNI completar completar completar Table ScanIX_VentaHist_DNI (DNI) INCLUDE (Fecha, Total) completar completar completar Index Seek 

5.3 Costo de mantener los índicesMediciónINSERT de 100.000 filas con 2 índices no agrupadosINSERT de 100.000 filas sin índicescompletarValormsEspacio de IX_VentaHist_Fecha_Cobertura / IX_VentaHist_DNI completar MB / completar MB 

6. Conclusiones 
(Validar y ajustar con las mediciones y capturas reales.) 
Sin índice la consulta recorre toda la tabla (Table Scan) y las lecturas lógicas son proporcionales al tamaño de la tabla, aunque el resultado sea una
fracción pequeña.
El índice agrupado sobre Fecha convierte el escaneo en un Seek sobre el rango pedido, y las lecturas bajan notablemente.
El índice con cobertura resuelve la consulta B leyendo solo el índice. Si la consulta pide columnas que el índice no incluye (consulta A), el
optimizador puede volver al escaneo o agregar búsquedas en la tabla (RID/Key Lookup), por lo que el índice debe diseñarse según las consultas
reales.
Para el historial de un cliente, un índice sobre DNI con las columnas consultadas en INCLUDE evita el escaneo completo.
Los índices tienen un costo: ocupan espacio adicional y los INSERT tardan más al tener que actualizarse cada uno. Conviene crear solo los
necesarios para las consultas frecuentes.


