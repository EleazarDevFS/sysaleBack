-- Verificar los datos actuales
SELECT id, tipo_tienda, url_web, horario_atencion FROM tienda_objetos;

-- Ver registros sin tipo_tienda
SELECT * FROM tienda_objetos WHERE tipo_tienda IS NULL;

-- Eliminar registros sin discriminador (si existen)
DELETE FROM tienda_objetos WHERE tipo_tienda IS NULL OR tipo_tienda = '';

-- Verificar que ya no hay registros problemáticos
SELECT id, tipo_tienda FROM tienda_objetos;
