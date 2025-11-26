package com.homework.sysale.model.types;

import lombok.Data;
import jakarta.persistence.Column;
import jakarta.persistence.Embeddable;

@Data
@Embeddable
public class TipoCategoria {
    
    @Column(name = "nombre", length = 100)
    private String nombre;
    
    @Column(name = "descripcion", columnDefinition = "TEXT")
    private String descripcion;
    
    @Column(name = "departamento", length = 50)
    private String departamento;
}