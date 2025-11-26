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
public class TipoProducto {
    
    @Column(name = "nombre", length = 150)
    private String nombre;
    
    @Column(name = "descripcion", columnDefinition = "TEXT")
    private String descripcion;
    
    @Column(name = "precio", precision = 10, scale = 2)
    private BigDecimal precio;
    
    @Column(name = "stock")
    private Integer stock;
    
    @Column(name = "activo")
    private Boolean activo;
    
    @Embedded
    @AttributeOverrides({
        @AttributeOverride(name = "nombre", column = @Column(name = "categoria_nombre")),
        @AttributeOverride(name = "descripcion", column = @Column(name = "categoria_descripcion")),
        @AttributeOverride(name = "departamento", column = @Column(name = "categoria_departamento"))
    })
    private TipoCategoria categoria;
}