-- ============================================
-- SISTEMA DE VENTAS - SCRIPT DE CREACIÓN DE BD
-- Estrategia: JOINED (Herencia con tablas separadas)
-- Base de Datos: PostgreSQL
-- ============================================

-- ============================================
-- TABLA BASE: tienda_objetos
-- Contiene información común de todas las tiendas
-- y el pedido embebido completo
-- ============================================
CREATE TABLE IF NOT EXISTS tienda_objetos (
    -- Identificador único
    id BIGSERIAL PRIMARY KEY,
    
    -- === DATOS DEL CLIENTE (Embeddable: TipoCliente) ===
    pedido_cliente_nombre VARCHAR(100),
    pedido_cliente_email VARCHAR(100),
    pedido_cliente_telefono VARCHAR(20),
    
    -- Dirección del Cliente (Embeddable: Direccion dentro de TipoCliente)
    pedido_cliente_direccion_calle VARCHAR(100),
    pedido_cliente_direccion_ciudad VARCHAR(50),
    pedido_cliente_direccion_codigo_postal VARCHAR(10),
    pedido_cliente_direccion_pais VARCHAR(50),
    
    -- === DATOS DEL PEDIDO (Embeddable: TipoPedido) ===
    pedido_fecha_pedido DATE,
    pedido_estado VARCHAR(20),
    pedido_total NUMERIC(10, 2),
    
    -- Constraints
    CONSTRAINT chk_pedido_total CHECK (pedido_total >= 0),
    CONSTRAINT chk_pedido_estado CHECK (pedido_estado IN ('PENDIENTE', 'PROCESANDO', 'ENVIADO', 'ENTREGADO', 'CANCELADO'))
);

-- Índices para tienda_objetos
CREATE INDEX IF NOT EXISTS idx_tienda_cliente_email ON tienda_objetos(pedido_cliente_email);
CREATE INDEX IF NOT EXISTS idx_tienda_fecha_pedido ON tienda_objetos(pedido_fecha_pedido);
CREATE INDEX IF NOT EXISTS idx_tienda_estado ON tienda_objetos(pedido_estado);

-- ============================================
-- TABLA: tienda_online
-- Hereda de tienda_objetos (JOINED)
-- Datos específicos de tiendas en línea
-- ============================================
CREATE TABLE IF NOT EXISTS tienda_online (
    -- PK y FK a la tabla padre
    id BIGINT PRIMARY KEY,
    
    -- Atributos específicos
    url_web VARCHAR(500),
    envio_gratis BOOLEAN DEFAULT FALSE,
    
    -- Foreign Key
    CONSTRAINT fk_tienda_online_objetos 
        FOREIGN KEY (id) REFERENCES tienda_objetos(id)
        ON DELETE CASCADE
);

-- Índice para tienda_online
CREATE INDEX IF NOT EXISTS idx_online_url ON tienda_online(url_web);

-- ============================================
-- TABLA: tienda_fisica
-- Hereda de tienda_objetos (JOINED)
-- Datos específicos de tiendas físicas
-- ============================================
CREATE TABLE IF NOT EXISTS tienda_fisica (
    -- PK y FK a la tabla padre
    id BIGINT PRIMARY KEY,
    
    -- Atributos específicos
    horario_atencion VARCHAR(255),
    numero_empleados INTEGER,
    
    -- Foreign Key
    CONSTRAINT fk_tienda_fisica_objetos 
        FOREIGN KEY (id) REFERENCES tienda_objetos(id)
        ON DELETE CASCADE,
    
    -- Constraints
    CONSTRAINT chk_numero_empleados CHECK (numero_empleados >= 0)
);

-- Índice para tienda_fisica
CREATE INDEX IF NOT EXISTS idx_fisica_horario ON tienda_fisica(horario_atencion);

-- ============================================
-- TABLA: pedido_detalles
-- @ElementCollection - Detalles del pedido
-- Contiene productos con toda su información embebida
-- ============================================
CREATE TABLE IF NOT EXISTS pedido_detalles (
    -- Identificador único (generado automáticamente)
    id BIGSERIAL PRIMARY KEY,
    
    -- Foreign Key a tienda_objetos
    tienda_objetos_id BIGINT NOT NULL,
    
    -- === DATOS DEL PRODUCTO (Embeddable: TipoProducto) ===
    detalle_producto_nombre VARCHAR(150) NOT NULL,
    detalle_producto_descripcion TEXT,
    detalle_producto_precio NUMERIC(10, 2) NOT NULL,
    detalle_producto_stock INTEGER,
    detalle_producto_activo BOOLEAN DEFAULT TRUE,
    
    -- Categoría del Producto (Embeddable: TipoCategoria dentro de TipoProducto)
    detalle_producto_categoria_nombre VARCHAR(100),
    detalle_producto_categoria_descripcion TEXT,
    detalle_producto_categoria_departamento VARCHAR(50),
    
    -- === DATOS DEL DETALLE (TipoDetallePedido) ===
    detalle_cantidad INTEGER NOT NULL,
    detalle_precio_unitario NUMERIC(10, 2) NOT NULL,
    
    -- Foreign Key
    CONSTRAINT fk_detalle_tienda 
        FOREIGN KEY (tienda_objetos_id) REFERENCES tienda_objetos(id)
        ON DELETE CASCADE,
    
    -- Constraints
    CONSTRAINT chk_detalle_cantidad CHECK (detalle_cantidad > 0),
    CONSTRAINT chk_detalle_precio CHECK (detalle_precio_unitario >= 0),
    CONSTRAINT chk_producto_precio CHECK (detalle_producto_precio >= 0),
    CONSTRAINT chk_producto_stock CHECK (detalle_producto_stock >= 0)
);

-- Índices para pedido_detalles
CREATE INDEX IF NOT EXISTS idx_detalle_tienda ON pedido_detalles(tienda_objetos_id);
CREATE INDEX IF NOT EXISTS idx_detalle_producto_nombre ON pedido_detalles(detalle_producto_nombre);
CREATE INDEX IF NOT EXISTS idx_detalle_categoria ON pedido_detalles(detalle_producto_categoria_nombre);

-- ============================================
-- VISTAS ÚTILES
-- ============================================

-- Vista: Información completa de Tiendas Online
CREATE OR REPLACE VIEW v_tiendas_online AS
SELECT 
    t.id,
    t.pedido_cliente_nombre AS cliente,
    t.pedido_cliente_email AS email,
    t.pedido_fecha_pedido AS fecha_pedido,
    t.pedido_estado AS estado,
    t.pedido_total AS total,
    o.url_web,
    o.envio_gratis
FROM tienda_objetos t
INNER JOIN tienda_online o ON t.id = o.id
ORDER BY t.pedido_fecha_pedido DESC;

-- Vista: Información completa de Tiendas Físicas
CREATE OR REPLACE VIEW v_tiendas_fisicas AS
SELECT 
    t.id,
    t.pedido_cliente_nombre AS cliente,
    t.pedido_cliente_email AS email,
    t.pedido_fecha_pedido AS fecha_pedido,
    t.pedido_estado AS estado,
    t.pedido_total AS total,
    f.horario_atencion,
    f.numero_empleados
FROM tienda_objetos t
INNER JOIN tienda_fisica f ON t.id = f.id
ORDER BY t.pedido_fecha_pedido DESC;

-- Vista: Resumen completo de pedidos con detalles
CREATE OR REPLACE VIEW v_resumen_pedidos AS
SELECT 
    t.id AS pedido_id,
    t.pedido_cliente_nombre AS cliente,
    t.pedido_cliente_email AS email,
    t.pedido_cliente_telefono AS telefono,
    t.pedido_fecha_pedido AS fecha,
    t.pedido_estado AS estado,
    t.pedido_total AS total,
    COUNT(d.id) AS cantidad_items,
    CASE 
        WHEN o.id IS NOT NULL THEN 'ONLINE'
        WHEN f.id IS NOT NULL THEN 'FISICA'
        ELSE 'DESCONOCIDO'
    END AS tipo_tienda
FROM tienda_objetos t
LEFT JOIN tienda_online o ON t.id = o.id
LEFT JOIN tienda_fisica f ON t.id = f.id
LEFT JOIN pedido_detalles d ON t.id = d.tienda_objetos_id
GROUP BY t.id, o.id, f.id
ORDER BY t.pedido_fecha_pedido DESC;

-- Vista: Productos más vendidos
CREATE OR REPLACE VIEW v_productos_mas_vendidos AS
SELECT 
    d.detalle_producto_nombre AS producto,
    d.detalle_producto_categoria_nombre AS categoria,
    d.detalle_producto_categoria_departamento AS departamento,
    SUM(d.detalle_cantidad) AS total_vendido,
    AVG(d.detalle_precio_unitario) AS precio_promedio,
    COUNT(DISTINCT d.tienda_objetos_id) AS cantidad_pedidos
FROM pedido_detalles d
GROUP BY 
    d.detalle_producto_nombre,
    d.detalle_producto_categoria_nombre,
    d.detalle_producto_categoria_departamento
ORDER BY total_vendido DESC;

-- Vista: Ventas por categoría
CREATE OR REPLACE VIEW v_ventas_por_categoria AS
SELECT 
    d.detalle_producto_categoria_nombre AS categoria,
    d.detalle_producto_categoria_departamento AS departamento,
    COUNT(DISTINCT d.tienda_objetos_id) AS cantidad_pedidos,
    SUM(d.detalle_cantidad) AS unidades_vendidas,
    SUM(d.detalle_cantidad * d.detalle_precio_unitario) AS ingresos_totales
FROM pedido_detalles d
GROUP BY 
    d.detalle_producto_categoria_nombre,
    d.detalle_producto_categoria_departamento
ORDER BY ingresos_totales DESC;

-- Vista: Clientes frecuentes
CREATE OR REPLACE VIEW v_clientes_frecuentes AS
SELECT 
    pedido_cliente_nombre AS cliente,
    pedido_cliente_email AS email,
    pedido_cliente_telefono AS telefono,
    COUNT(*) AS total_pedidos,
    SUM(pedido_total) AS total_gastado,
    AVG(pedido_total) AS promedio_gasto,
    MAX(pedido_fecha_pedido) AS ultimo_pedido
FROM tienda_objetos
WHERE pedido_cliente_email IS NOT NULL
GROUP BY 
    pedido_cliente_nombre,
    pedido_cliente_email,
    pedido_cliente_telefono
ORDER BY total_pedidos DESC;

-- ============================================
-- FUNCIONES ÚTILES
-- ============================================

-- Función: Calcular subtotal de un detalle
CREATE OR REPLACE FUNCTION calcular_subtotal_detalle(
    p_cantidad INTEGER,
    p_precio_unitario NUMERIC(10, 2)
)
RETURNS NUMERIC(10, 2) AS $$
BEGIN
    RETURN p_cantidad * p_precio_unitario;
END;
$$ LANGUAGE plpgsql IMMUTABLE;

-- Función: Obtener tipo de tienda
CREATE OR REPLACE FUNCTION obtener_tipo_tienda(p_tienda_id BIGINT)
RETURNS VARCHAR(10) AS $$
DECLARE
    v_tipo VARCHAR(10);
BEGIN
    IF EXISTS (SELECT 1 FROM tienda_online WHERE id = p_tienda_id) THEN
        v_tipo := 'ONLINE';
    ELSIF EXISTS (SELECT 1 FROM tienda_fisica WHERE id = p_tienda_id) THEN
        v_tipo := 'FISICA';
    ELSE
        v_tipo := 'NINGUNO';
    END IF;
    
    RETURN v_tipo;
END;
$$ LANGUAGE plpgsql;

-- ============================================
-- TRIGGERS
-- ============================================

-- Trigger: Validar que una tienda sea ONLINE o FISICA (no ambas)
CREATE OR REPLACE FUNCTION validar_tipo_tienda()
RETURNS TRIGGER AS $$
BEGIN
    -- Verificar si ya existe en la otra tabla
    IF TG_TABLE_NAME = 'tienda_online' THEN
        IF EXISTS (SELECT 1 FROM tienda_fisica WHERE id = NEW.id) THEN
            RAISE EXCEPTION 'La tienda con id % ya existe como tienda física', NEW.id;
        END IF;
    ELSIF TG_TABLE_NAME = 'tienda_fisica' THEN
        IF EXISTS (SELECT 1 FROM tienda_online WHERE id = NEW.id) THEN
            RAISE EXCEPTION 'La tienda con id % ya existe como tienda online', NEW.id;
        END IF;
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_validar_tienda_online
    BEFORE INSERT OR UPDATE ON tienda_online
    FOR EACH ROW
    EXECUTE FUNCTION validar_tipo_tienda();

CREATE TRIGGER trg_validar_tienda_fisica
    BEFORE INSERT OR UPDATE ON tienda_fisica
    FOR EACH ROW
    EXECUTE FUNCTION validar_tipo_tienda();

-- ============================================
-- COMENTARIOS EN LAS TABLAS
-- ============================================

COMMENT ON TABLE tienda_objetos IS 'Tabla base para todas las tiendas (Estrategia JOINED). Contiene el pedido completo con cliente embebido.';
COMMENT ON TABLE tienda_online IS 'Tiendas en línea - Hereda de tienda_objetos';
COMMENT ON TABLE tienda_fisica IS 'Tiendas físicas - Hereda de tienda_objetos';
COMMENT ON TABLE pedido_detalles IS 'Detalles de cada pedido con información completa del producto (@ElementCollection)';

COMMENT ON COLUMN tienda_objetos.pedido_total IS 'Total del pedido en formato decimal (10,2)';
COMMENT ON COLUMN tienda_objetos.pedido_estado IS 'Estado actual: PENDIENTE, PROCESANDO, ENVIADO, ENTREGADO, CANCELADO';
COMMENT ON COLUMN tienda_online.envio_gratis IS 'Indica si la tienda ofrece envío gratis';
COMMENT ON COLUMN tienda_fisica.numero_empleados IS 'Cantidad de empleados en la tienda física';
COMMENT ON COLUMN pedido_detalles.detalle_cantidad IS 'Cantidad de productos en este detalle';
COMMENT ON COLUMN pedido_detalles.detalle_precio_unitario IS 'Precio unitario al momento de la compra';

-- ============================================
-- FIN DEL SCRIPT
-- ============================================
