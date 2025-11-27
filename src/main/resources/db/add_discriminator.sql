-- ============================================
-- SCRIPT: Datos de Ejemplo
-- Propósito: Insertar datos de prueba
-- Incluye tiendas online y físicas con pedidos
-- ============================================

-- Limpiar datos existentes (opcional)
-- DELETE FROM pedido_detalles;
-- DELETE FROM tienda_online;
-- DELETE FROM tienda_fisica;
-- DELETE FROM tienda_objetos;
-- ALTER SEQUENCE tienda_objetos_id_seq RESTART WITH 1;
-- ALTER SEQUENCE pedido_detalles_id_seq RESTART WITH 1;

-- ============================================
-- TIENDAS ONLINE CON PEDIDOS
-- ============================================

-- Tienda Online 1: Electrónica Express
INSERT INTO tienda_objetos (
    pedido_cliente_nombre, pedido_cliente_email, pedido_cliente_telefono,
    pedido_cliente_direccion_calle, pedido_cliente_direccion_ciudad,
    pedido_cliente_direccion_codigo_postal, pedido_cliente_direccion_pais,
    pedido_fecha_pedido, pedido_estado, pedido_total
) VALUES (
    'Juan Pérez', 'juan.perez@email.com', '+34-600-123-456',
    'Calle Mayor 123', 'Madrid', '28001', 'España',
    CURRENT_DATE, 'PROCESANDO', 1299.99
);

INSERT INTO tienda_online (id, url_web, envio_gratis)
VALUES (currval('tienda_objetos_id_seq'), 'https://electronica-express.com', true);

-- Detalles del pedido 1
INSERT INTO pedido_detalles (
    tienda_objetos_id,
    detalle_producto_nombre, detalle_producto_descripcion, detalle_producto_precio,
    detalle_producto_stock, detalle_producto_activo,
    detalle_producto_categoria_nombre, detalle_producto_categoria_descripcion, detalle_producto_categoria_departamento,
    detalle_cantidad, detalle_precio_unitario
) VALUES
(
    currval('tienda_objetos_id_seq'),
    'Laptop HP Pavilion 15', 'Laptop con procesador Intel i7, 16GB RAM, 512GB SSD', 899.99,
    10, true,
    'Computadoras', 'Equipos de cómputo y accesorios', 'Electrónica',
    1, 899.99
),
(
    currval('tienda_objetos_id_seq'),
    'Mouse Logitech MX Master 3', 'Mouse inalámbrico ergonómico de alta precisión', 99.99,
    50, true,
    'Accesorios', 'Accesorios para computadoras', 'Electrónica',
    2, 99.99
),
(
    currval('tienda_objetos_id_seq'),
    'Teclado Mecánico RGB', 'Teclado mecánico retroiluminado con switches Cherry MX', 149.99,
    30, true,
    'Accesorios', 'Accesorios para computadoras', 'Electrónica',
    2, 149.99
);

-- Tienda Online 2: Moda Online Store
INSERT INTO tienda_objetos (
    pedido_cliente_nombre, pedido_cliente_email, pedido_cliente_telefono,
    pedido_cliente_direccion_calle, pedido_cliente_direccion_ciudad,
    pedido_cliente_direccion_codigo_postal, pedido_cliente_direccion_pais,
    pedido_fecha_pedido, pedido_estado, pedido_total
) VALUES (
    'María García', 'maria.garcia@email.com', '+34-611-234-567',
    'Avenida Diagonal 456', 'Barcelona', '08001', 'España',
    CURRENT_DATE - INTERVAL '2 days', 'ENVIADO', 249.97
);

INSERT INTO tienda_online (id, url_web, envio_gratis)
VALUES (currval('tienda_objetos_id_seq'), 'https://moda-online.es', true);

-- Detalles del pedido 2
INSERT INTO pedido_detalles (
    tienda_objetos_id,
    detalle_producto_nombre, detalle_producto_descripcion, detalle_producto_precio,
    detalle_producto_stock, detalle_producto_activo,
    detalle_producto_categoria_nombre, detalle_producto_categoria_descripcion, detalle_producto_categoria_departamento,
    detalle_cantidad, detalle_precio_unitario
) VALUES
(
    currval('tienda_objetos_id_seq'),
    'Camisa de algodón', 'Camisa elegante 100% algodón', 49.99,
    100, true,
    'Ropa', 'Ropa casual y formal', 'Moda',
    3, 49.99
),
(
    currval('tienda_objetos_id_seq'),
    'Pantalón vaquero', 'Pantalón denim clásico', 79.99,
    75, true,
    'Ropa', 'Ropa casual y formal', 'Moda',
    1, 79.99
);

-- ============================================
-- TIENDAS FÍSICAS CON PEDIDOS
-- ============================================

-- Tienda Física 1: SuperMercado Central
INSERT INTO tienda_objetos (
    pedido_cliente_nombre, pedido_cliente_email, pedido_cliente_telefono,
    pedido_cliente_direccion_calle, pedido_cliente_direccion_ciudad,
    pedido_cliente_direccion_codigo_postal, pedido_cliente_direccion_pais,
    pedido_fecha_pedido, pedido_estado, pedido_total
) VALUES (
    'Carlos Rodríguez', 'carlos.rodriguez@email.com', '+34-622-345-678',
    'Plaza Mayor 10', 'Sevilla', '41001', 'España',
    CURRENT_DATE - INTERVAL '5 days', 'ENTREGADO', 156.50
);

INSERT INTO tienda_fisica (id, horario_atencion, numero_empleados)
VALUES (currval('tienda_objetos_id_seq'), 'Lunes a Sábado: 9:00 - 21:00, Domingo: 10:00 - 14:00', 25);

-- Detalles del pedido 3
INSERT INTO pedido_detalles (
    tienda_objetos_id,
    detalle_producto_nombre, detalle_producto_descripcion, detalle_producto_precio,
    detalle_producto_stock, detalle_producto_activo,
    detalle_producto_categoria_nombre, detalle_producto_categoria_descripcion, detalle_producto_categoria_departamento,
    detalle_cantidad, detalle_precio_unitario
) VALUES
(
    currval('tienda_objetos_id_seq'),
    'Arroz Integral 1kg', 'Arroz integral de grano largo', 2.50,
    200, true,
    'Alimentos', 'Productos de alimentación', 'Supermercado',
    5, 2.50
),
(
    currval('tienda_objetos_id_seq'),
    'Aceite de Oliva Extra Virgen 1L', 'Aceite de oliva de primera presión en frío', 8.99,
    150, true,
    'Alimentos', 'Productos de alimentación', 'Supermercado',
    3, 8.99
),
(
    currval('tienda_objetos_id_seq'),
    'Café Premium 500g', 'Café en grano tostado artesanalmente', 12.99,
    80, true,
    'Bebidas', 'Bebidas y cafés', 'Supermercado',
    10, 12.99
);

-- Tienda Física 2: Librería El Saber
INSERT INTO tienda_objetos (
    pedido_cliente_nombre, pedido_cliente_email, pedido_cliente_telefono,
    pedido_cliente_direccion_calle, pedido_cliente_direccion_ciudad,
    pedido_cliente_direccion_codigo_postal, pedido_cliente_direccion_pais,
    pedido_fecha_pedido, pedido_estado, pedido_total
) VALUES (
    'Ana Martínez', 'ana.martinez@email.com', '+34-633-456-789',
    'Calle de Alcalá 234', 'Madrid', '28009', 'España',
    CURRENT_DATE - INTERVAL '1 day', 'PROCESANDO', 89.95
);

INSERT INTO tienda_fisica (id, horario_atencion, numero_empleados)
VALUES (currval('tienda_objetos_id_seq'), 'Lunes a Viernes: 10:00 - 20:00, Sábado: 10:00 - 14:00', 8);

-- Detalles del pedido 4
INSERT INTO pedido_detalles (
    tienda_objetos_id,
    detalle_producto_nombre, detalle_producto_descripcion, detalle_producto_precio,
    detalle_producto_stock, detalle_producto_activo,
    detalle_producto_categoria_nombre, detalle_producto_categoria_descripcion, detalle_producto_categoria_departamento,
    detalle_cantidad, detalle_precio_unitario
) VALUES
(
    currval('tienda_objetos_id_seq'),
    'Clean Code - Robert C. Martin', 'Libro sobre buenas prácticas de programación', 44.99,
    15, true,
    'Libros Técnicos', 'Libros de programación y tecnología', 'Librería',
    2, 44.99
);

-- ============================================
-- VERIFICAR DATOS INSERTADOS
-- ============================================

-- Ver resumen de tiendas
SELECT 'Tiendas Online' AS tipo, COUNT(*) AS total FROM tienda_online
UNION ALL
SELECT 'Tiendas Físicas', COUNT(*) FROM tienda_fisica
UNION ALL
SELECT 'Total Pedidos', COUNT(*) FROM tienda_objetos
UNION ALL
SELECT 'Total Detalles', COUNT(*) FROM pedido_detalles;
