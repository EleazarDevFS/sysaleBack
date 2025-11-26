package com.homework.sysale.model.types;

import jakarta.persistence.AttributeOverride;
import jakarta.persistence.AttributeOverrides;
import jakarta.persistence.Column;
import jakarta.persistence.Embeddable;
import jakarta.persistence.Embedded;
import lombok.Data;

@Data
@Embeddable
public class TipoCliente {
    
    @Column(name = "nombre", length = 100)
    private String nombre;
    
    @Column(name = "email", length = 100)
    private String email;
    
    @Column(name = "telefono", length = 20)
    private String telefono;
    
    @Embedded
    @AttributeOverrides({
        @AttributeOverride(name = "calle", column = @Column(name = "cliente_calle")),
        @AttributeOverride(name = "ciudad", column = @Column(name = "cliente_ciudad")),
        @AttributeOverride(name = "codigoPostal", column = @Column(name = "cliente_codigo_postal")),
        @AttributeOverride(name = "pais", column = @Column(name = "cliente_pais"))
    })
    private Direccion direccion;
}