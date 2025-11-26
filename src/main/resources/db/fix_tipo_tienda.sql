-- Actualizar registros existentes con un tipo por defecto
-- Opción 1: Marcar todos como ONLINE
UPDATE tienda_objetos 
SET tipo_tienda = 'ONLINE' 
WHERE tipo_tienda IS NULL OR tipo_tienda = '';

-- Verificar el resultado
SELECT id, tipo_tienda, url_web, horario_atencion FROM tienda_objetos;
