# Contribución Individual — Etapa 2

**Equipo:** 57  
**Integrante:** Romero, Josefina Belén  
**Fecha:** 23-09-26

---

## Aporte realizado

Análisis y aplicación de la **Segunda Forma Normal (2FN)** sobre el esquema relacional del sistema resultante de la 1FN.

Se realizó la verificación de que todos los atributos no clave dependan funcionalmente de forma completa de su clave primaria.

Se confirmó que las entidades **CLIENTE, VENTA, PRENDA, CATEGORIA y METODO_PAGO** cumplen automáticamente con la 2FN al poseer claves primarias simples.

También se realizó el análisis de las tablas con **Clave Primaria Compuesta**.

---

## Problemas o dificultades identificadas

- Comprender cómo analizar formalmente las dependencias funcionales en tablas intermedias que poseen claves primarias compuestas (**CONTIENE** y **ABONA_CON**).
- Determinar si el atributo `Precio_Historico` de la tabla **CONTIENE** dependía únicamente de la prenda o de la combinación de la venta y la prenda.

---

## Soluciones

- Se analizó la regla de negocio **RN.03 (Historial de Precios Unitarios)**, concluyendo que el precio refleja el valor de la prenda en ese instante exacto de la venta. Por lo tanto, `Precio_Historico` depende de la clave compuesta (`fk_VENTA`, `fk_PRENDA`) y no de `fk_PRENDA` de manera aislada.

- Se concluyó que no existen dependencias parciales en el esquema relacional, por lo que el modelo resultante de la 1FN ya se encontraba en **2FN**, sin requerir la creación de nuevas tablas.

---

## Evidencia

[Normalizacion.md](https://github.com/josefina-belen/proyecto-bd1-equipo_57/blob/main/docs/etapa-02/Normalizacion.md)

---

## Reflexión

Desarrollé una comprensión más profunda sobre el concepto de **dependencia funcional completa** y la razón por la cual la **Segunda Forma Normal (2FN)** se relaciona con las tablas que poseen claves primarias compuestas.

Aprendí a utilizar las reglas de negocio del sistema junto con la teoría relacional para justificar por qué un atributo pertenece a una tabla específica y cómo determinar si existen dependencias parciales.
