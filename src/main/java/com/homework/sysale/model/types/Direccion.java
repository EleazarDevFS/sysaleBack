package com.homework.sysale.model.types;

import jakarta.persistence.Column;
import jakarta.persistence.Embeddable;
import lombok.Data;


@Data
@Embeddable
public class Direccion {
    
    @Column(name = "calle", length = 100)
    private String calle;
    
    @Column(name = "ciudad", length = 50)
    private String ciudad;
    
    @Column(name = "codigo_postal", length = 10)
    private String codigoPostal;
    
    @Column(name = "pais", length = 50)
    private String pais;
}
