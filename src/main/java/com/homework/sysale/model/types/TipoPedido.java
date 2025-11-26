package com.homework.sysale.model.types;

import lombok.Data;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

import jakarta.persistence.AttributeOverride;
import jakarta.persistence.AttributeOverrides;
import jakarta.persistence.CollectionTable;
import jakarta.persistence.Column;
import jakarta.persistence.ElementCollection;
import jakarta.persistence.Embeddable;
import jakarta.persistence.Embedded;
import jakarta.persistence.JoinColumn;

@Data
@Embeddable
public class TipoPedido {
    
    @Embedded
    @AttributeOverrides({
        @AttributeOverride(name = "nombre", column = @Column(name = "cliente_nombre")),
        @AttributeOverride(name = "email", column = @Column(name = "cliente_email")),
        @AttributeOverride(name = "telefono", column = @Column(name = "cliente_telefono")),
        @AttributeOverride(name = "direccion.calle", column = @Column(name = "cliente_direccion_calle")),
        @AttributeOverride(name = "direccion.ciudad", column = @Column(name = "cliente_direccion_ciudad")),
        @AttributeOverride(name = "direccion.codigoPostal", column = @Column(name = "cliente_direccion_codigo_postal")),
        @AttributeOverride(name = "direccion.pais", column = @Column(name = "cliente_direccion_pais"))
    })
    private TipoCliente cliente;
    
    @Column(name = "fecha_pedido")
    private LocalDate fechaPedido;
    
    @Column(name = "estado", length = 20)
    private String estado;
    
    @ElementCollection
    @CollectionTable(name = "pedido_detalles", joinColumns = @JoinColumn(name = "tienda_objetos_id"))
    @AttributeOverrides({
        @AttributeOverride(name = "producto.nombre", column = @Column(name = "detalle_producto_nombre")),
        @AttributeOverride(name = "producto.descripcion", column = @Column(name = "detalle_producto_descripcion")),
        @AttributeOverride(name = "producto.precio", column = @Column(name = "detalle_producto_precio")),
        @AttributeOverride(name = "producto.stock", column = @Column(name = "detalle_producto_stock")),
        @AttributeOverride(name = "producto.activo", column = @Column(name = "detalle_producto_activo")),
        @AttributeOverride(name = "producto.categoria.nombre", column = @Column(name = "detalle_producto_categoria_nombre")),
        @AttributeOverride(name = "producto.categoria.descripcion", column = @Column(name = "detalle_producto_categoria_descripcion")),
        @AttributeOverride(name = "producto.categoria.departamento", column = @Column(name = "detalle_producto_categoria_departamento")),
        @AttributeOverride(name = "cantidad", column = @Column(name = "detalle_cantidad")),
        @AttributeOverride(name = "precioUnitario", column = @Column(name = "detalle_precio_unitario"))
    })
    private List<TipoDetallePedido> detalles = new ArrayList<>();
    
    @Column(name = "total", precision = 10, scale = 2)
    private BigDecimal total;
}