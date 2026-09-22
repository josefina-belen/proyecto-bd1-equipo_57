# Reglas de Negocio — Sistema de Ventas

Este documento define las reglas de negocio (RN) del proceso de venta: alta de clientes, stock, precios, medios de pago y estructura del comprobante.

## RN.01 — Registro de Clientes

Toda venta debe estar asociada a un cliente registrado en el sistema. Para el alta es obligatorio ingresar DNI (identificador único), nombre y apellido.

## RN.02 — Gestión de Stock

Toda prenda comercializada debe contar con un registro de unidades disponibles. Al confirmar un comprobante, el sistema descuenta automáticamente la cantidad adquirida. No se pueden registrar ventas si el stock es insuficiente.

## RN.03 — Historial de Precios Unitarios

Cada renglón del detalle de venta debe capturar de forma permanente el precio unitario de la prenda en el instante de la operación. Así, cambios futuros en la lista de precios no afectan el total de comprobantes ya emitidos.

## RN.04 — Métodos de Pago

Es obligatorio registrar en el comprobante el método de pago utilizado por el cliente: Efectivo, Débito, Crédito o Transferencia.

## RN.05 — Estructura de la Venta

Un comprobante de venta se emite para un único cliente y debe contener como mínimo un renglón de detalle (al menos una prenda) para ser válido.

## RN.06 — Variantes de Producto

El sistema considera como artículos distintos a nivel de stock a las prendas que, compartiendo el mismo modelo, difieran en talle o color. Ejemplo: una remera talle M color negro y talle M color blanco son dos artículos con stock independiente.
