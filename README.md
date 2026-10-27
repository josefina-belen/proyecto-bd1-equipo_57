# Estilo Urbano — Sistema de Gestión de Ventas

**Proyecto académico de Bases de Datos I · Equipo 57

**
Integrantes: 

Sistema de base de datos relacional diseñado para gestionar las operaciones principales de una tienda de indumentaria: clientes, catálogo de prendas, inventario, ventas y medios de pago.

El proyecto busca aplicar los fundamentos del diseño y la implementación de bases de datos relacionales, priorizando la integridad de los datos, la reducción de redundancias y la trazabilidad de las operaciones comerciales.

---

## Tabla de contenidos
 [Descripción](https://github.com/josefina-belen/proyecto-bd1-equipo_57#tabla-de-contenidos)

---

## Descripción del proyecto

*Estilo Urbano* es un caso de estudio de una tienda de indumentaria que necesita organizar la información de sus clientes, productos, existencias y operaciones de venta.

La solución se implementa mediante una base de datos relacional en Microsoft SQL Server. El modelo contempla la gestión de prendas por talle, color y categoría, así como el registro de comprobantes de venta, sus detalles y los importes abonados mediante distintos medios de pago.

El diseño también contempla el almacenamiento del precio histórico de cada artículo vendido, de manera que las modificaciones posteriores del precio de catálogo no alteren el valor registrado en las operaciones anteriores.

## Objetivos

- Diseñar un modelo de datos relacional adecuado al dominio del negocio.
- Aplicar los principios de normalización para reducir redundancias y anomalías de actualización.
- Implementar claves primarias, claves foráneas y restricciones de integridad.
- Representar las relaciones entre clientes, productos, ventas y medios de pago.
- Desarrollar consultas SQL que permitan recuperar y analizar información comercial.
- Validar el comportamiento de la base de datos mediante pruebas reproducibles.
- Documentar las decisiones de diseño y los procedimientos de instalación y ejecución.

## Alcance funcional

El modelo de datos contempla las siguientes áreas:

| Área | Descripción |
|---|---|
| Clientes | Registro de datos identificatorios y de contacto. |
| Catálogo | Organización de prendas por categoría, talle, color y modelo. |
| Inventario | Registro de existencias y precio actual de cada artículo. |
| Ventas | Registro de comprobantes asociados a clientes. |
| Detalle de ventas | Artículos vendidos, cantidades y precios históricos. |
| Medios de pago | Registro de los medios de pago y los importes abonados. |

### Fuera del alcance

La versión definida del caso de estudio no contempla la gestión de compras a proveedores, devoluciones, cambios de prendas ni logística de envíos.

## Modelo de datos

El esquema relacional se compone de siete tablas:

| Tabla | Responsabilidad |
|---|---|
| `CLIENTE` | Almacena la información de los clientes. |
| `CATEGORIA` | Clasifica las prendas comercializadas. |
| `PRENDA` | Registra el catálogo, las variantes, los precios y el stock. |
| `VENTA` | Representa la cabecera de cada comprobante. |
| `CONTIENE` | Relaciona ventas y prendas, registrando cantidades y precios históricos. |
| `METODO_PAGO` | Define los medios de pago disponibles. |
| `ABONA_CON` | Registra los importes abonados por venta y medio de pago. |

Las relaciones entre las entidades se implementan mediante claves primarias y foráneas. Las tablas `CONTIENE` y `ABONA_CON` permiten representar relaciones de muchos a muchos.

### Diagrama entidad-relación
![`docs/etapa-02/der/der.png`](docs/etapa-02/der/der.png)

### Modelo relacional
<img width="1498" height="565" alt="image" src="https://github.com/user-attachments/assets/45870dfc-1b68-4fa4-8f7b-2911e0215473" />


### Normalización

- [Primera Forma Normal (1FN)](https://github.com/josefina-belen/proyecto-bd1-equipo_57/blob/main/docs/etapa-02/Normalizacion.md#1-primera-forma-normal-1fn)
- [Segunda Forma Normal (2FN)](https://github.com/josefina-belen/proyecto-bd1-equipo_57/blob/main/docs/etapa-02/Normalizacion.md#segunda-forma-normal-2fn)
- [Tercera Forma Normal (3FN)](https://github.com/josefina-belen/proyecto-bd1-equipo_57/blob/main/docs/etapa-02/Normalizacion.md#tercera-forma-normal-3fn)


## Tecnologías

- **Motor de base de datos:** Microsoft SQL Server.
- **Lenguaje:** SQL / T-SQL.
- **Herramienta de desarrollo y ejecución:** SQL Server Management Studio (SSMS).
- **Control de versiones y colaboración:**  GitHub.
- **Documentación:** Markdown.

## Estructura del repositorio

```text
proyecto-bd1-equipo_57/
├── README.md
├── docs/
│   ├── etapa-01/
│   │   ├── alcance.md
│   │   ├── descripcion-caso.md
│   │   ├── reglas-negocio.md
│   │   └── decisiones-diseno.md
│   ├── etapa-02/
│   │   ├── der/
│   │   ├── Normalizacion.md
│   │   ├── modelo-relacional.md
│   │   └── Decisiones-diseno.md
│   ├── etapa-03/
│   │   ├── implementacion.md
│   │   ├── restricciones-integridad.md
│   │   └── pruebas-validacion.md
│   ├── etapa-04/
│   └── etapa-05/
└── sql/
    ├── ddl/
    │   └── crear_bd.sql
    ├── dml/
    │   └── datos_prueba.sql
    ├── consultas/
    │   ├── comprobante_venta.sql
    │   ├── informe_ventas.sql
    │   └── consulta_avanzada.sql
    ├── pruebas_de_validacion/
    │   └── 01_pruebas.sql
    └── tecnico/
```

La estructura organiza los scripts de SQL y la documentación por responsabilidad y etapa de desarrollo.

## Instalación y ejecución

### Requisitos previos

- Una instancia de Microsoft SQL Server accesible.
- SQL Server Management Studio (SSMS) u otra herramienta compatible con T-SQL.
- Permisos suficientes para crear la base de datos y sus objetos.

### Paso 1. Crear la base de datos y las tablas

Abrir el archivo [`sql/ddl/crear_bd.sql`](sql/ddl/crear_bd.sql) en SSMS y ejecutarlo sobre una instancia de SQL Server.

Este script crea la base de datos `PROYECTO` y define las siete tablas junto con sus claves y restricciones.

> El script está pensado para una instalación inicial. Si la base de datos `PROYECTO` ya existe, no debe ejecutarse nuevamente sin preparar antes un procedimiento de reinicialización.

### Paso 2. Cargar los datos de prueba

Una vez creada la estructura, abrir y ejecutar:

[`sql/dml/datos_prueba.sql`](sql/dml/datos_prueba.sql)

Este archivo inserta registros de ejemplo para clientes, categorías, prendas, ventas, detalles y pagos, y permite consultar el contenido de las tablas.

**Importante:** la carga de prueba actual presupone una base recién creada y determinados valores de identificadores autogenerados. Para volver a ejecutarla, debe prepararse una base limpia o adaptarse el script para que sea repetible de forma segura.

### Paso 3. Ejecutar las consultas

Las consultas se organizan en `sql/consultas/`. Los archivos previstos para comprobantes, informes y análisis avanzado deben completarse y validarse antes de considerarse entregables funcionales.

### Paso 4. Ejecutar las pruebas

Abrir [`sql/pruebas_de_validacion/01_pruebas.sql`](sql/pruebas_de_validacion/01_pruebas.sql) y ejecutar las validaciones en una base de pruebas.

Los resultados deben compararse con resultados esperados. Se recomienda no ejecutar pruebas destructivas sobre una base con información que se quiera conservar.

## Integridad y reglas de negocio

El diseño incorpora mecanismos de integridad para proteger la consistencia de los datos:

- Claves primarias para identificar los registros.
- Claves foráneas para mantener las relaciones entre las tablas.
- Restricciones `CHECK` para validar determinados valores, como precios positivos, cantidades mayores que cero y stock no negativo.
- Restricción de unicidad para los nombres de las categorías.
- Restricciones referenciales para controlar las operaciones sobre registros relacionados.
- Almacenamiento del precio histórico en el detalle de venta.
- Relaciones que permiten registrar más de un medio de pago para una misma venta.

Las reglas que requieren coordinación entre varias operaciones —como el descuento automático del stock, la validación integral de una venta y la conciliación del total abonado— deben implementarse y probarse mediante la lógica SQL correspondiente antes de considerarse garantizadas.

## Pruebas y validación

El repositorio incluye un script inicial de pruebas de restricciones e integridad referencial.




## Documentación

La documentación se encuentra organizada en la carpeta [`docs/`](docs/).

- **Etapa 1:** descripción del caso, alcance y reglas de negocio.
- **Etapa 2:** modelo de datos, diagrama entidad-relación y normalización.
- **Etapa 3:** implementación SQL, restricciones y pruebas de validación.
- **Etapa 4:** casos de uso, comprobantes e informes.
- **Etapa 5:** optimización, procedimientos, funciones, seguridad, transacciones y auditoría.



## Estado del proyecto

El proyecto cuenta con una definición del caso de negocio, un modelo relacional implementado en SQL Server, datos de prueba y una base de validaciones.

Actualmente se trabaja en completar las consultas requeridas, fortalecer las reglas de negocio que necesitan lógica transaccional, ampliar las pruebas y consolidar la documentación técnica.

El estado de cada funcionalidad debe actualizarse a partir de su implementación y validación efectiva.

## Equipo de trabajo

**Equipo 57 — Bases de Datos I**

Proyecto académico colaborativo desarrollado con control de versiones mediante GitHub.

Los integrantes y sus responsabilidades se documentaron aquí cuando se acuerdan la distribución definitiva del trabajo.

---

*Proyecto académico con fines educativos. La información de los registros de prueba es ficticia y se utiliza para validar el diseño y el funcionamiento de la base de datos.*
