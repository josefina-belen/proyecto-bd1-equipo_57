# Contribución individual -- Etapa 2

- **Equipo:** 57 
- **Integrante:** Aldana Georgina Zalazar
- **Fecha:** 22/09/2026

---

### 1. Aporte realizado
Diseñé y realicé el Modelo Relacional completo utilizando ERDplus a partir del trabajo previo de mi compañero. Además, le hice correcciones al DER de mi compañero Pablo sumando la estructura detallada de la dirección del cliente y el monto específico en las relaciones de pago.

### 2. Decisiones en las que participé
Definí que la base de datos debía estar preparada para manejar pagos combinados (por ejemplo, abonar una parte en efectivo y otra con tarjeta). También decidí que era clave normalizar la ubicación de los clientes separando los datos para facilitar futuras consultas o filtros por zona.

### 3. Problemas o dificultades identificadas
Revisando el DER original, vi que no contemplaba el detalle de la ubicación de los clientes. También noté que faltaba especificar el monto abonado al utilizar un método de pago particular en una venta, lo cual era necesario para cumplir con las reglas del negocio.

### 4. Soluciones o propuestas realizadas
Edité el DER agregando `Direccion` (como atributo compuesto) a la entidad `Cliente`, y sumé `Monto_Abonado` a la relación `Abona_con`. Después, me aseguré de que todas estas soluciones se tradujeran correctamente y sin errores al Modelo Relacional final.

### 5. Evidencias en el repositorio
* **Mis commits:** [Ver historial de commits de Aldana](https://github.com/josefina-belen/proyecto-bd1-equipo_57/commits/main/?author=danazalazar)
* **Archivo del diagrama subido:** [docs/etapa-02/modelo-relacional.md](docs/etapa-02/modelo-relacional.md)

### 6. Reflexión individual
Al realizar el Modelo Relacional, me di cuenta de la importancia de traducir cada entidad y relación a tablas con sus respectivas PK y FK para que la estructura sea sólida. Entendí que el trabajo en equipo no es solo hacer mi parte, sino aprender a revisar lo que hace mi compañero para ver si está bien y proponer correcciones. Además, me sirvió para agarrarle la mano a GitHub y aprender a registrar mis cambios con commits.
