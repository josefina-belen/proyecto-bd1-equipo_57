# Etapa 5 – Triggers de auditoría

**Proyecto:** Estilo Urbano – Sistema de Gestión de Ventas 

**Contenido de esta carpeta:**
- `investigacion.md`: este documento.
---

## 1. Definición y objetivo

Un **trigger** (disparador) es un procedimiento almacenado que SQL Server ejecuta de forma automática cuando ocurre un evento `INSERT`, `UPDATE` o `DELETE` sobre una tabla. El usuario no lo invoca: se dispara solo, dentro de la misma operación que lo originó.

Dentro de SQL Server existen dos tipos que usamos en este trabajo:

| Tipo | Cuándo se ejecuta | Uso en el proyecto |
|---|---|---|
| `AFTER` | Después de que la operación se realizó y superó todas las restricciones (`CHECK`, `FK`). | Auditoría de `UPDATE` y `DELETE`. |
| `INSTEAD OF` | **En lugar de** la operación: la sentencia original no se ejecuta. | Bloquear el `DELETE` sobre `VENTA`. |

Dentro del trigger se dispone de dos tablas temporales especiales:

- `deleted`: las filas **antes** del cambio (en un `UPDATE`, los valores viejos; en un `DELETE`, las filas eliminadas).
- `inserted`: las filas **después** del cambio (en un `UPDATE`, los valores nuevos).

**Objetivo:** dotar al sistema de *trazabilidad*, para poder responder: ¿quién modificó un precio?, ¿cuándo se eliminó una prenda o un cliente?, ¿qué valor tenía antes?; y de *protección*, impidiendo borrar comprobantes de venta.

## 2. Ventajas y aplicaciones

- **Trazabilidad automática:** el registro no depende de que cada aplicación o usuario "se acuerde" de auditar. Ocurre siempre.
- **Control de cambios:** se conserva el valor anterior de cada dato modificado o eliminado, por lo que un error puede revertirse.
- **Seguridad e integridad:** el trigger `INSTEAD OF` impone una regla de negocio en la base, sin importar desde dónde se ejecute el `DELETE`.
- **Centralización:** la regla vive en un solo lugar de la base de datos.
- **Aplicaciones típicas:** historial de precios, bitácora de clientes eliminados, protección de registros legales o contables, detección de modificaciones no autorizadas.

Contras a tener presentes: cada `UPDATE`/`DELETE` hace trabajo extra (una escritura en la tabla de auditoría), y la lógica "invisible" de un trigger puede sorprender a quien no lo conoce, por eso se documenta.

## 3. Implementación en SQL Server

### 3.1 Tablas de auditoría

| Tabla | Audita a | Columnas de control |
|---|---|---|
| `AUDITORIA_PRENDA` | `PRENDA` | `ID_Auditoria`, `Operacion`, `Fecha_Hora`, `Usuario_Login`, `Usuario_BD` |
| `AUDITORIA_CLIENTE` | `CLIENTE` | las mismas |

Además tienen una columna `*_Anterior` por cada columna de la tabla original (siempre completa) y una columna `*_Nuevo` (completa solo en `UPDATE`; queda en `NULL` en un `DELETE`). Los tipos de dato son idénticos a los de las tablas originales. Las tablas de auditoría **no tienen clave foránea** hacia las tablas auditadas, de modo que el historial se conserva aunque la fila original ya no exista.

### 3.2 Triggers creados

| Trigger | Tabla | Tipo | Evento | Qué hace |
|---|---|---|---|---|
| `trg_PRENDA_AuditoriaUpdate` | `PRENDA` | `AFTER` | `UPDATE` | Guarda valores anteriores y nuevos. |
| `trg_PRENDA_AuditoriaDelete` | `PRENDA` | `AFTER` | `DELETE` | Guarda los valores de la prenda eliminada. |
| `trg_CLIENTE_AuditoriaUpdate` | `CLIENTE` | `AFTER` | `UPDATE` | Guarda valores anteriores y nuevos. |
| `trg_CLIENTE_AuditoriaDelete` | `CLIENTE` | `AFTER` | `DELETE` | Guarda los valores del cliente eliminado. |
| `trg_VENTA_BloquearDelete` | `VENTA` | `INSTEAD OF` | `DELETE` | Emite el error 50001 y no borra nada. |

### 3.3 Decisiones de diseño

- **Set-based:** los triggers no usan variables ni cursores. Un `UPDATE` que afecta varias filas dispara el trigger una sola vez y genera una fila de auditoría por cada fila afectada.
- **Fecha y hora:** `SYSDATETIME()`, con precisión de milisegundos (`DATETIME2(3)`).
- **Usuario:** se registra `ORIGINAL_LOGIN()` (el login real de la conexión, aunque se use `EXECUTE AS`) y `USER_NAME()` (el usuario de la base de datos que realizó la operación, tal como pide la consigna).
- **Solo UPDATE y DELETE:** son las operaciones que destruyen o alteran información. El `INSERT` no pierde datos previos, por eso no se audita.
- **`LEFT JOIN deleted → inserted` por clave primaria:** garantiza que toda fila modificada quede auditada. Si un `UPDATE` cambia la propia clave primaria (por ejemplo, el `Codigo_SKU`), no hay forma de emparejar la fila vieja con la nueva, y las columnas `*_Nuevo` quedan en `NULL`; igualmente el valor anterior queda registrado.
- **Por qué `INSTEAD OF` en `VENTA`:** un comprobante de venta es un registro comercial que no debe borrarse; además, por el `ON DELETE CASCADE` del modelo, borrarlo arrastraría su detalle (`CONTIENE`) y sus pagos (`ABONA_CON`). SQL Server no permite `INSTEAD OF DELETE` en tablas con una FK `ON DELETE CASCADE` definida en ellas (`CONTIENE` y `ABONA_CON`), pero `VENTA` sí lo admite porque su única FK (hacia `CLIENTE`) es `ON DELETE NO ACTION`.
- **`IF EXISTS (SELECT 1 FROM deleted)`:** un `DELETE` que no afecta ninguna fila no genera error.
- **Re-ejecutable:** se usa `IF OBJECT_ID(...) IS NULL` para las tablas y `CREATE OR ALTER` para los triggers.

### 3.4 Interacción con las restricciones existentes

Los triggers `AFTER` actúan *después* de las restricciones. Si una `FK` o `CHECK` rechaza la operación, el trigger no se ejecuta y **no queda auditoría**, porque el cambio nunca ocurrió. Esto se demuestra en la Prueba 6.

## 4. Caso concreto en el sistema de ventas

Un empleado modifica por error el precio y el stock de la prenda 1001 (Remera Basic). Sin auditoría, el valor anterior se pierde. Con el trigger:

```sql
UPDATE dbo.PRENDA
SET Precio_Actual = 18000.00, Stock = 18
WHERE Codigo_SKU = 1001;
