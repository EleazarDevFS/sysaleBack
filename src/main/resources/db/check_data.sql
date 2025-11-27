-- ============================================
-- SCRIPT: Verificación de Datos
-- Propósito: Consultas útiles para revisar el estado
-- de la base de datos y las transacciones
-- ============================================

-- ============================================
-- CONSULTAS BÁSICAS
-- ============================================

-- Ver todas las tiendas online
SELECT 
    t.id,
    t.pedido_cliente_nombre AS cliente,
    t.pedido_cliente_email AS email,
    t.pedido_fecha_pedido AS fecha,
    t.pedido_estado AS estado,
    t.pedido_total AS total,
    o.url_web,
    o.envio_gratis
FROM tienda_objetos t
INNER JOIN tienda_online o ON t.id = o.id
ORDER BY t.pedido_fecha_pedido DESC;

-- Ver todas las tiendas físicas
SELECT 
    t.id,
    t.pedido_cliente_nombre AS cliente,
    t.pedido_cliente_email AS email,
    t.pedido_fecha_pedido AS fecha,
    t.pedido_estado AS estado,
    t.pedido_total AS total,
    f.horario_atencion,
    f.numero_empleados
FROM tienda_objetos t
INNER JOIN tienda_fisica f ON t.id = f.id
ORDER BY t.pedido_fecha_pedido DESC;

-- ============================================
-- VERIFICAR INTEGRIDAD DE DATOS
-- ============================================

-- Verificar que todas las tiendas tienen un tipo (JOINED)
SELECT 
    'Total en tienda_objetos' AS descripcion,
    COUNT(*) AS cantidad
FROM tienda_objetos
UNION ALL
SELECT 
    'Total tiendas online',
    COUNT(*)
FROM tienda_online
UNION ALL
SELECT 
    'Total tiendas físicas',
    COUNT(*)
FROM tienda_fisica
UNION ALL
SELECT 
    'Tiendas sin tipo (ERROR)',
    COUNT(*)
FROM tienda_objetos t
WHERE NOT EXISTS (SELECT 1 FROM tienda_online o WHERE o.id = t.id)
  AND NOT EXISTS (SELECT 1 FROM tienda_fisica f WHERE f.id = t.id);

-- Verificar pedidos sin detalles
SELECT 
    t.id,
    t.pedido_cliente_nombre,
    t.pedido_total,
    COUNT(d.id) AS num_detalles
FROM tienda_objetos t
LEFT JOIN pedido_detalles d ON t.id = d.tienda_objetos_id
GROUP BY t.id, t.pedido_cliente_nombre, t.pedido_total
HAVING COUNT(d.id) = 0;

-- Verificar consistencia de totales
SELECT 
    t.id,
    t.pedido_cliente_nombre,
    t.pedido_total AS total_registrado,
    COALESCE(SUM(d.detalle_cantidad * d.detalle_precio_unitario), 0) AS total_calculado,
    t.pedido_total - COALESCE(SUM(d.detalle_cantidad * d.detalle_precio_unitario), 0) AS diferencia
FROM tienda_objetos t
LEFT JOIN pedido_detalles d ON t.id = d.tienda_objetos_id
GROUP BY t.id, t.pedido_cliente_nombre, t.pedido_total
HAVING ABS(t.pedido_total - COALESCE(SUM(d.detalle_cantidad * d.detalle_precio_unitario), 0)) > 0.01;

-- ============================================
-- ESTADÍSTICAS GENERALES
-- ============================================

-- Resumen de pedidos por estado
SELECT 
    pedido_estado AS estado,
    COUNT(*) AS cantidad_pedidos,
    SUM(pedido_total) AS total_ventas,
    AVG(pedido_total) AS promedio_venta,
    MIN(pedido_total) AS venta_minima,
    MAX(pedido_total) AS venta_maxima
FROM tienda_objetos
GROUP BY pedido_estado
ORDER BY cantidad_pedidos DESC;

-- Pedidos por tipo de tienda
SELECT 
    CASE 
        WHEN o.id IS NOT NULL THEN 'ONLINE'
        WHEN f.id IS NOT NULL THEN 'FISICA'
        ELSE 'SIN TIPO'
    END AS tipo_tienda,
    COUNT(*) AS cantidad_pedidos,
    SUM(t.pedido_total) AS total_ventas,
    AVG(t.pedido_total) AS promedio_venta
FROM tienda_objetos t
LEFT JOIN tienda_online o ON t.id = o.id
LEFT JOIN tienda_fisica f ON t.id = f.id
GROUP BY tipo_tienda;

-- Top 10 productos más vendidos
SELECT 
    d.detalle_producto_nombre AS producto,
    d.detalle_producto_categoria_nombre AS categoria,
    SUM(d.detalle_cantidad) AS unidades_vendidas,
    COUNT(DISTINCT d.tienda_objetos_id) AS num_pedidos,
    AVG(d.detalle_precio_unitario) AS precio_promedio,
    SUM(d.detalle_cantidad * d.detalle_precio_unitario) AS ingresos_totales
FROM pedido_detalles d
GROUP BY 
    d.detalle_producto_nombre,
    d.detalle_producto_categoria_nombre
ORDER BY unidades_vendidas DESC
LIMIT 10;

-- Ventas por categoría
SELECT 
    d.detalle_producto_categoria_departamento AS departamento,
    d.detalle_producto_categoria_nombre AS categoria,
    COUNT(DISTINCT d.tienda_objetos_id) AS pedidos,
    SUM(d.detalle_cantidad) AS unidades,
    SUM(d.detalle_cantidad * d.detalle_precio_unitario) AS ingresos
FROM pedido_detalles d
GROUP BY 
    d.detalle_producto_categoria_departamento,
    d.detalle_producto_categoria_nombre
ORDER BY ingresos DESC;

-- Clientes con más pedidos
SELECT 
    pedido_cliente_nombre AS cliente,
    pedido_cliente_email AS email,
    COUNT(*) AS total_pedidos,
    SUM(pedido_total) AS total_gastado,
    AVG(pedido_total) AS gasto_promedio,
    MAX(pedido_fecha_pedido) AS ultimo_pedido
FROM tienda_objetos
WHERE pedido_cliente_email IS NOT NULL
GROUP BY pedido_cliente_nombre, pedido_cliente_email
ORDER BY total_pedidos DESC, total_gastado DESC
LIMIT 10;

-- ============================================
-- VERIFICAR CONSTRAINTS Y VALIDACIONES
-- ============================================

-- Verificar que no haya totales negativos
SELECT 
    'Pedidos con total negativo' AS problema,
    COUNT(*) AS cantidad
FROM tienda_objetos
WHERE pedido_total < 0;

-- Verificar detalles con cantidades inválidas
SELECT 
    'Detalles con cantidad <= 0' AS problema,
    COUNT(*) AS cantidad
FROM pedido_detalles
WHERE detalle_cantidad <= 0;

-- Verificar precios inválidos
SELECT 
    'Detalles con precio negativo' AS problema,
    COUNT(*) AS cantidad
FROM pedido_detalles
WHERE detalle_precio_unitario < 0;

-- Verificar stock negativo
SELECT 
    'Productos con stock negativo' AS problema,
    COUNT(*) AS cantidad
FROM pedido_detalles
WHERE detalle_producto_stock < 0;

-- ============================================
-- CONSULTAS DE ANÁLISIS TEMPORAL
-- ============================================

-- Pedidos de los últimos 7 días
SELECT 
    DATE(pedido_fecha_pedido) AS fecha,
    COUNT(*) AS num_pedidos,
    SUM(pedido_total) AS ventas_totales,
    AVG(pedido_total) AS venta_promedio
FROM tienda_objetos
WHERE pedido_fecha_pedido >= CURRENT_DATE - INTERVAL '7 days'
GROUP BY DATE(pedido_fecha_pedido)
ORDER BY fecha DESC;

-- Pedidos por estado actual (últimos 30 días)
SELECT 
    pedido_estado,
    COUNT(*) AS cantidad,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) AS porcentaje
FROM tienda_objetos
WHERE pedido_fecha_pedido >= CURRENT_DATE - INTERVAL '30 days'
GROUP BY pedido_estado
ORDER BY cantidad DESC;

-- ============================================
-- LIMPIAR DATOS (USAR CON PRECAUCIÓN)
-- ============================================

-- DESCOMENTA SOLO SI NECESITAS LIMPIAR LA BASE DE DATOS
/*
BEGIN;

-- Eliminar todos los detalles
DELETE FROM pedido_detalles;

-- Eliminar tiendas específicas
DELETE FROM tienda_online;
DELETE FROM tienda_fisica;

-- Eliminar tabla base
DELETE FROM tienda_objetos;

-- Reiniciar secuencias
ALTER SEQUENCE tienda_objetos_id_seq RESTART WITH 1;
ALTER SEQUENCE pedido_detalles_id_seq RESTART WITH 1;

COMMIT;

SELECT 'Base de datos limpiada exitosamente' AS resultado;
*/

-- ============================================
-- VERIFICACIÓN FINAL
-- ============================================

SELECT 
    'Verificación completada' AS mensaje,
    CURRENT_TIMESTAMP AS fecha_hora;
