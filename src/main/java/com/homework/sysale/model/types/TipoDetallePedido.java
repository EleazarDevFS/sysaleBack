package com.homework.sysale.model.types;

import lombok.Data;
import java.math.BigDecimal;

import jakarta.persistence.AttributeOverride;
import jakarta.persistence.AttributeOverrides;
import jakarta.persistence.Column;
import jakarta.persistence.Embeddable;
import jakarta.persistence.Embedded;

@Data
@Embeddable
public class TipoDetallePedido {
    
    @Embedded
    @AttributeOverrides({
        @AttributeOverride(name = "nombre", column = @Column(name = "producto_nombre")),
        @AttributeOverride(name = "descripcion", column = @Column(name = "producto_descripcion")),
        @AttributeOverride(name = "precio", column = @Column(name = "producto_precio")),
        @AttributeOverride(name = "stock", column = @Column(name = "producto_stock")),
        @AttributeOverride(name = "activo", column = @Column(name = "producto_activo")),
        @AttributeOverride(name = "categoria.nombre", column = @Column(name = "producto_categoria_nombre")),
        @AttributeOverride(name = "categoria.descripcion", column = @Column(name = "producto_categoria_descripcion")),
        @AttributeOverride(name = "categoria.departamento", column = @Column(name = "producto_categoria_departamento"))
    })
    private TipoProducto producto;
    
    @Column(name = "cantidad")
    private Integer cantidad;
    
    @Column(name = "precio_unitario", precision = 10, scale = 2)
    private BigDecimal precioUnitario;
}