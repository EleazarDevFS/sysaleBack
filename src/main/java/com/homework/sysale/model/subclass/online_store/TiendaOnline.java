package com.homework.sysale.model.subclass.online_store;

import com.homework.sysale.model.superclass.TiendaObjetos;

import jakarta.persistence.Entity;
import jakarta.persistence.Table;
import lombok.Data;
import lombok.EqualsAndHashCode;


@Data
@EqualsAndHashCode(callSuper = true)
@Entity
@Table(name = "tienda_online")
public class TiendaOnline extends TiendaObjetos{
    private String urlWeb;
    private Boolean envioGratis;
}
