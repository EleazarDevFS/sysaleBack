-- Agregar la columna discriminadora si no existe
ALTER TABLE tienda_objetos 
ADD COLUMN IF NOT EXISTS tipo_tienda VARCHAR(31);

-- Actualizar registros existentes (opcional, si ya hay datos)
UPDATE tienda_objetos 
SET tipo_tienda = 'ONLINE' 
WHERE url_web IS NOT NULL;

UPDATE tienda_objetos 
SET tipo_tienda = 'FISICA' 
WHERE horario_atencion IS NOT NULL;
