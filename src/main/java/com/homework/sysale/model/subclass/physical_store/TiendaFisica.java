package com.homework.sysale.model.subclass.physical_store;

import com.homework.sysale.model.superclass.TiendaObjetos;

import jakarta.persistence.Entity;
import jakarta.persistence.Table;
import lombok.Data;
import lombok.EqualsAndHashCode;

@Data
@EqualsAndHashCode(callSuper = true)
@Entity
@Table(name = "tienda_fisica")
public class TiendaFisica extends TiendaObjetos {
    private String horarioAtencion;
    private Integer numeroEmpleados;
}
