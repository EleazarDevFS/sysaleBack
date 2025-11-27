-- ============================================
-- SCRIPT: Ejemplos de Transacciones SQL
-- Propósito: Demostrar uso de BEGIN, COMMIT, ROLLBACK
-- Estos ejemplos muestran transacciones a nivel SQL
-- El backend usa transacciones programáticas (PlatformTransactionManager)
-- ============================================

-- ============================================
-- EJEMPLO 1: Transacción Exitosa
-- Registrar un pedido completo con todos sus detalles
-- ============================================

BEGIN;

-- 1. Insertar datos base de la tienda
INSERT INTO tienda_objetos (
    pedido_cliente_nombre, pedido_cliente_email, pedido_cliente_telefono,
    pedido_cliente_direccion_calle, pedido_cliente_direccion_ciudad,
    pedido_cliente_direccion_codigo_postal, pedido_cliente_direccion_pais,
    pedido_fecha_pedido, pedido_estado, pedido_total
) VALUES (
    'Pedro Sánchez', 'pedro.sanchez@email.com', '+34-644-567-890',
    'Calle Luna 88', 'Valencia', '46001', 'España',
    CURRENT_DATE, 'PENDIENTE', 459.97
);

-- 2. Insertar en tabla específica (tienda online)
INSERT INTO tienda_online (id, url_web, envio_gratis)
VALUES (currval('tienda_objetos_id_seq'), 'https://tech-store.es', true);

-- 3. Insertar detalles del pedido
INSERT INTO pedido_detalles (
    tienda_objetos_id,
    detalle_producto_nombre, detalle_producto_descripcion, detalle_producto_precio,
    detalle_producto_stock, detalle_producto_activo,
    detalle_producto_categoria_nombre, detalle_producto_categoria_descripcion,
    detalle_producto_categoria_departamento,
    detalle_cantidad, detalle_precio_unitario
) VALUES
(
    currval('tienda_objetos_id_seq'),
    'Monitor LG 27" 4K', 'Monitor UHD 4K con HDR', 349.99,
    20, true,
    'Monitores', 'Pantallas y monitores', 'Electrónica',
    1, 349.99
),
(
    currval('tienda_objetos_id_seq'),
    'Webcam Logitech C920', 'Webcam Full HD 1080p', 89.99,
    35, true,
    'Accesorios', 'Accesorios para PC', 'Electrónica',
    1, 89.99
);

-- Si todo está correcto, confirmar la transacción
COMMIT;

SELECT 'Transacción COMMIT exitosa' AS resultado;

-- ============================================
-- EJEMPLO 2: Transacción con ROLLBACK
-- Intentar operación inválida y revertir
-- ============================================

-- Guardar punto actual
SELECT COUNT(*) AS pedidos_antes FROM tienda_objetos;

BEGIN;

-- Insertar un pedido
INSERT INTO tienda_objetos (
    pedido_cliente_nombre, pedido_cliente_email,
    pedido_fecha_pedido, pedido_estado, pedido_total
) VALUES (
    'Cliente Temporal', 'temporal@email.com',
    CURRENT_DATE, 'PENDIENTE', 100.00
);

INSERT INTO tienda_online (id, url_web, envio_gratis)
VALUES (currval('tienda_objetos_id_seq'), 'https://temp-store.com', false);

-- Simular un error o decisión de cancelar
-- Por ejemplo: validación de negocio falla
ROLLBACK;

SELECT 'Transacción ROLLBACK ejecutada - cambios revertidos' AS resultado;

-- Verificar que no se insertó nada
SELECT COUNT(*) AS pedidos_despues FROM tienda_objetos;

-- ============================================
-- EJEMPLO 3: Transacción con SAVEPOINT
-- Punto de guardado parcial dentro de transacción
-- ============================================

BEGIN;

-- Insertar pedido principal
INSERT INTO tienda_objetos (
    pedido_cliente_nombre, pedido_cliente_email,
    pedido_fecha_pedido, pedido_estado, pedido_total
) VALUES (
    'Laura Fernández', 'laura.fernandez@email.com',
    CURRENT_DATE, 'PENDIENTE', 299.98
);

INSERT INTO tienda_fisica (id, horario_atencion, numero_empleados)
VALUES (currval('tienda_objetos_id_seq'), 'L-V: 9:00-18:00', 12);

-- Crear punto de guardado
SAVEPOINT antes_detalles;

-- Intentar insertar detalles
INSERT INTO pedido_detalles (
    tienda_objetos_id,
    detalle_producto_nombre, detalle_producto_precio,
    detalle_producto_categoria_nombre, detalle_producto_categoria_departamento,
    detalle_cantidad, detalle_precio_unitario
) VALUES
(
    currval('tienda_objetos_id_seq'),
    'Producto Válido', 149.99,
    'Categoría A', 'Departamento',
    2, 149.99
);

-- Si algo falla en los detalles, podemos volver al savepoint
-- ROLLBACK TO SAVEPOINT antes_detalles;

-- Si todo está bien, confirmar
COMMIT;

SELECT 'Transacción con SAVEPOINT completada' AS resultado;

-- ============================================
-- EJEMPLO 4: Transacción con validaciones
-- ============================================

DO $$
DECLARE
    v_tienda_id BIGINT;
    v_total NUMERIC(10,2) := 0;
BEGIN
    -- Iniciar transacción implícita
    
    -- Insertar tienda
    INSERT INTO tienda_objetos (
        pedido_cliente_nombre, pedido_cliente_email,
        pedido_fecha_pedido, pedido_estado, pedido_total
    ) VALUES (
        'Roberto López', 'roberto.lopez@email.com',
        CURRENT_DATE, 'PENDIENTE', 0
    ) RETURNING id INTO v_tienda_id;
    
    INSERT INTO tienda_online (id, url_web, envio_gratis)
    VALUES (v_tienda_id, 'https://gadgets-online.com', true);
    
    -- Insertar detalles
    INSERT INTO pedido_detalles (
        tienda_objetos_id,
        detalle_producto_nombre, detalle_producto_precio,
        detalle_producto_categoria_nombre, detalle_producto_categoria_departamento,
        detalle_cantidad, detalle_precio_unitario
    ) VALUES
    (v_tienda_id, 'Smartphone Samsung', 599.99, 'Móviles', 'Electrónica', 1, 599.99),
    (v_tienda_id, 'Funda protectora', 19.99, 'Accesorios', 'Electrónica', 2, 19.99);
    
    -- Calcular total
    SELECT SUM(detalle_cantidad * detalle_precio_unitario)
    INTO v_total
    FROM pedido_detalles
    WHERE tienda_objetos_id = v_tienda_id;
    
    -- Actualizar total
    UPDATE tienda_objetos
    SET pedido_total = v_total
    WHERE id = v_tienda_id;
    
    -- Validar que el total sea correcto
    IF v_total < 0 OR v_total IS NULL THEN
        RAISE EXCEPTION 'Total inválido calculado';
    END IF;
    
    RAISE NOTICE 'Transacción completada. Total: %', v_total;
    
EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'Error: %. Realizando ROLLBACK', SQLERRM;
        RAISE;
END $$;

-- ============================================
-- NOTAS IMPORTANTES
-- ============================================
-- 
-- 1. En el backend de Spring Boot, las transacciones se manejan con:
--    - @Transactional (anotación declarativa)
--    - PlatformTransactionManager (programática - usada en este proyecto)
--
-- 2. El PlatformTransactionManager equivale a:
--    - getTransaction() -> BEGIN
--    - commit() -> COMMIT  
--    - rollback() -> ROLLBACK
--
-- 3. Ver los servicios TiendaOnlineService y TiendaFisicaService
--    para ejemplos de transacciones programáticas en Java
-- ============================================
