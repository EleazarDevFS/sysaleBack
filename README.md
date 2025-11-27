# SysAle - Sistema de Gestión de Ventas

Sistema backend desarrollado en **Spring Boot** que implementa un modelo de ventas robusto usando **Programación Orientada a Objetos (POO)** y **Bases de Datos Orientadas a Objetos (BDOO)**.

## Características Principales

- API RESTful con Spring Boot
- Arquitectura orientada a objetos con herencia y polimorfismo
- Mapeo objeto-relacional (JPA/Hibernate)
- **Transacciones programáticas** (BEGIN/COMMIT/ROLLBACK)
- Base de datos PostgreSQL con estrategia JOINED
- Documentación automática con Swagger/OpenAPI
- CORS configurado para integración frontend

---

## Conceptos de POO Implementados

### 1. **Herencia (Inheritance)**
El sistema utiliza **herencia** para modelar diferentes tipos de tiendas:

```java
// Clase abstracta base
@Entity
@Inheritance(strategy = InheritanceType.JOINED)
public abstract class TiendaObjetos {
    private Long id;
    private TipoPedido pedido;
}

// Clases derivadas
@Entity
public class TiendaOnline extends TiendaObjetos {
    private String urlWeb;
    private Boolean envioGratis;
}

@Entity
public class TiendaFisica extends TiendaObjetos {
    private String horarioAtencion;
    private Integer numeroEmpleados;
}
```

### 2. **Encapsulamiento (Encapsulation)**
Uso de tipos embebidos para agrupar datos relacionados:

```java
@Embeddable
public class TipoPedido {
    private TipoCliente cliente;
    private LocalDate fechaPedido;
    private String estado;
    private List<TipoDetallePedido> detalles;
    private BigDecimal total;
}

@Embeddable
public class TipoCliente {
    private String nombre;
    private String email;
    private String telefono;
    private Direccion direccion;  // Composición
}
```

### 3. **Polimorfismo (Polymorphism)**
Los controladores y servicios trabajan con la abstracción, permitiendo operaciones polimórficas:

```java
// El servicio base maneja cualquier tipo de tienda
public class TiendaObjetosService {
    public List<TiendaObjetos> findAll() {
        return repository.findAll(); // Retorna TiendaOnline o TiendaFisica
    }
}
```

### 4. **Composición (Composition)**
Objetos complejos compuestos por otros objetos:

```
TiendaObjetos
    └── TipoPedido
            ├── TipoCliente
            │       └── Direccion
            └── List<TipoDetallePedido>
                    └── TipoProducto
                            └── TipoCategoria
```

---

## Conceptos de BDOO Implementados

### 1. **Estrategia JOINED**
Cada clase de la jerarquía tiene su propia tabla:

```
tienda_objetos (tabla base)
    ├── id, pedido_cliente_*, pedido_fecha_pedido, etc.
    │
    ├── tienda_online (tabla hija)
    │       └── id (FK), url_web, envio_gratis
    │
    └── tienda_fisica (tabla hija)
            └── id (FK), horario_atencion, numero_empleados
```

### 2. **Objetos Embebidos (@Embedded)**
Tipos complejos almacenados en la misma tabla:

```sql
-- TipoPedido embebido en tienda_objetos
CREATE TABLE tienda_objetos (
    pedido_cliente_nombre VARCHAR(100),
    pedido_cliente_email VARCHAR(100),
    pedido_cliente_direccion_calle VARCHAR(100),
    pedido_fecha_pedido DATE,
    pedido_total NUMERIC(10, 2)
);
```

### 3. **Colecciones (@ElementCollection)**
Listas de objetos embebidos en tabla separada:

```sql
-- Detalles del pedido como colección
CREATE TABLE pedido_detalles (
    tienda_objetos_id BIGINT REFERENCES tienda_objetos(id),
    detalle_producto_nombre VARCHAR(150),
    detalle_cantidad INTEGER,
    detalle_precio_unitario NUMERIC(10, 2)
);
```

---

## Transacciones Programáticas

El sistema implementa transacciones usando **PlatformTransactionManager** para garantizar la integridad de las operaciones críticas:

```java
public TiendaOnline save(TiendaOnline tienda) {
    DefaultTransactionDefinition def = new DefaultTransactionDefinition();
    TransactionStatus status = transactionManager.getTransaction(def);
    
    try {
        // BEGIN - inicia la transacción
        System.out.println("[TRANSACCIÓN] BEGIN");
        
        TiendaOnline saved = repository.save(tienda);
        
        // COMMIT - confirma la transacción
        transactionManager.commit(status);
        System.out.println("[TRANSACCIÓN] COMMIT");
        
        return saved;
    } catch (RuntimeException ex) {
        // ROLLBACK - revierte en caso de error
        transactionManager.rollback(status);
        System.err.println("[TRANSACCIÓN] ROLLBACK");
        throw ex;
    }
}
```

> [!TIP]
> Las transacciones se ejecutan automáticamente al crear o actualizar pedidos. Revisa los logs en consola para ver el flujo BEGIN → COMMIT/ROLLBACK.

---

## 🚀 Configuración e Instalación

### Prerrequisitos

- Java 21+
- PostgreSQL 12+
- Gradle 8+

### 1. Clonar el repositorio

```bash
git clone https://github.com/EleazarDevFS/sysaleBack.git
cd sysale
```

### 2. Configurar variables de entorno

Crea un archivo `.env` en la raíz del proyecto:

```bash
# .env
export URL_DATABASE=jdbc:postgresql://localhost:5432/sysale_db
export USER_DATABASE=postgres
export PASSWORD_DATABASE=tu_password_aqui

export CORS_ALLOWED_ORIGINS=http://localhost:3000
export CORS_ALLOWED_METHODS=GET,POST,PUT,PATCH,DELETE,OPTIONS
```

> [!IMPORTANT]
> Asegúrate de cambiar `tu_password_aqui` por tu contraseña de PostgreSQL.

### 3. Cargar variables de entorno

```bash
source .env
```

### 4. Crear la base de datos

```sql
-- Conectarse a PostgreSQL
psql -U postgres

-- Crear la base de datos
CREATE DATABASE sysale;
```

### 5. Ejecutar el script SQL

```bash
psql -U postgres -d sysale -f src/main/resources/db/schema.sql
```

> [!TIP]
> Opcionalmente, puedes cargar datos de ejemplo:
> ```bash
> psql -U postgres -d sysale -f src/main/resources/db/add_discriminator.sql
> ```

### 6. Compilar y ejecutar

```bash
# Compilar el proyecto
./gradlew build

# Ejecutar la aplicación
./gradlew bootRun
```

La aplicación estará disponible en: `http://localhost:8080`

---

## 📚 Documentación Adicional

### Scripts SQL
En el directorio `src/main/resources/db/` encontrarás:

| Archivo | Descripción |
|---------|-------------|
| `schema.sql` | Creación completa de la BD con tablas, vistas, funciones y triggers |
| `add_discriminator.sql` | Datos de ejemplo para pruebas |
| `fix_tipo_tienda.sql` | Ejemplos de transacciones SQL (BEGIN/COMMIT/ROLLBACK) |
| `check_data.sql` | Consultas útiles para verificar datos e integridad |

### Diagramas UML
En el directorio `docs/` encontrarás:

| Archivo | Descripción |
|---------|-------------|
| `class-diagram.puml` | Diagrama de clases del modelo de dominio |
| `database-diagram.puml` | Diagrama de la estructura de base de datos |

> [!NOTE]
> Los archivos `.puml` pueden visualizarse con PlantUML o en VS Code con la extensión PlantUML.

---

## API Endpoints

### Tiendas Base
```http
GET    /api/tienda          # Listar todas las tiendas
GET    /api/tienda/{id}     # Obtener tienda por ID
```

### Tiendas Online
```http
GET    /api/tienda/online           # Listar tiendas online
GET    /api/tienda/online/{id}      # Obtener por ID
POST   /api/tienda/online           # Crear (con transacción)
PUT    /api/tienda/online/{id}      # Actualizar
DELETE /api/tienda/online/{id}      # Eliminar
```

### Tiendas Físicas
```http
GET    /api/tienda/physical         # Listar tiendas físicas
GET    /api/tienda/physical/{id}    # Obtener por ID
POST   /api/tienda/physical         # Crear (con transacción)
PUT    /api/tienda/physical/{id}    # Actualizar
DELETE /api/tienda/physical/{id}    # Eliminar
```

### Documentación Interactiva

- **Swagger UI**: http://localhost:8080/swagger-ui.html
- **OpenAPI Docs**: http://localhost:8080/api-docs

---

## Estructura del Proyecto

```
sysale/
├── src/
│   ├── main/
│   │   ├── java/com/homework/sysale/
│   │   │   ├── config/          # Configuración (CORS, etc.)
│   │   │   ├── controller/      # Controladores REST
│   │   │   ├── model/           # Entidades JPA
│   │   │   │   ├── superclass/  # Clase base (TiendaObjetos)
│   │   │   │   ├── subclass/    # Clases derivadas
│   │   │   │   └── types/       # Tipos embebidos
│   │   │   ├── repository/      # Repositorios JPA
│   │   │   └── service/         # Lógica de negocio (transacciones)
│   │   └── resources/
│   │       ├── application.properties
│   │       └── db/              # Scripts SQL
│   └── test/                    # Tests unitarios
├── docs/                        # Diagramas UML
├── build.gradle                 # Configuración Gradle
└── README.md                    # Este archivo
```

---

## Ejemplo de Uso

### Crear una tienda online con pedido (transacción automática)

```bash
curl -X POST http://localhost:8080/api/tienda/online \
  -H "Content-Type: application/json" \
  -d '{
    "urlWeb": "https://mi-tienda.com",
    "envioGratis": true,
    "pedido": {
      "cliente": {
        "nombre": "Juan Pérez",
        "email": "juan@email.com",
        "telefono": "+34-600-123-456",
        "direccion": {
          "calle": "Calle Mayor 123",
          "ciudad": "Madrid",
          "codigoPostal": "28001",
          "pais": "España"
        }
      },
      "fechaPedido": "2025-11-26",
      "estado": "PENDIENTE",
      "total": 299.99,
      "detalles": [
        {
          "producto": {
            "nombre": "Laptop HP",
            "descripcion": "Laptop i7 16GB RAM",
            "precio": 899.99,
            "stock": 10,
            "activo": true,
            "categoria": {
              "nombre": "Computadoras",
              "descripcion": "Equipos de cómputo",
              "departamento": "Electrónica"
            }
          },
          "cantidad": 1,
          "precioUnitario": 899.99
        }
      ]
    }
  }'
```

> [!TIP]
> Revisa los logs del servidor para ver la traza de la transacción:
> ```
> [TRANSACCIÓN] BEGIN - Iniciando registro de tienda online
> [TRANSACCIÓN] Pedido registrado para tienda ID: 1
> [TRANSACCIÓN] Total del pedido: 299.99
> [TRANSACCIÓN] COMMIT - Tienda online guardada exitosamente
> ```

---

## Troubleshooting

### Error de conexión a PostgreSQL

> [!WARNING]
> Si obtienes `Connection refused`, verifica que PostgreSQL esté ejecutándose:
> ```bash
> sudo systemctl status postgresql
> sudo systemctl start postgresql
> ```

### Variables de entorno no cargadas

```bash
# Verificar que las variables estén disponibles
echo $URL_DATABASE

# Si no aparece nada, ejecuta:
source .env
```

### Error en transacciones

Si ves errores de transacciones en los logs, verifica que `spring.jpa.hibernate.ddl-auto=update` esté configurado en `application.properties`.

---

## Tecnologías Utilizadas

| Tecnología | Versión | Propósito |
|------------|---------|-----------|
| Java | 17 | Lenguaje base |
| Spring Boot | 3.x | Framework backend |
| Spring Data JPA | 3.x | ORM y persistencia |
| Hibernate | 6.x | Implementación JPA |
| PostgreSQL | 12+ | Base de datos |
| Lombok | Latest | Reducir boilerplate |
| Gradle | 8+ | Gestión de dependencias |
| SpringDoc OpenAPI | 2.x | Documentación API |

---

## Referencias

- [Spring Boot Documentation](https://docs.spring.io/spring-boot/)
- [Spring Data JPA](https://docs.spring.io/spring-data/jpa/)
- [JPA Inheritance Strategies](https://www.baeldung.com/hibernate-inheritance)
- [PostgreSQL Documentation](https://www.postgresql.org/docs/)

---

## Autor

**Eleazar**  
GitHub: [@EleazarDevFS](https://github.com/EleazarDevFS)

---

