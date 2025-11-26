package com.homework.sysale.model.superclass;

import com.homework.sysale.model.types.TipoPedido;
import lombok.Data;

import jakarta.persistence.AttributeOverride;
import jakarta.persistence.AttributeOverrides;
import jakarta.persistence.Column;
import jakarta.persistence.Embedded;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Inheritance;
import jakarta.persistence.InheritanceType;
import jakarta.persistence.Table;

@Data
@Entity
@Table(name = "tienda_objetos")
@Inheritance(strategy = InheritanceType.JOINED)
public abstract class TiendaObjetos {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @Embedded
    @AttributeOverrides({
        @AttributeOverride(name = "cliente.nombre", column = @Column(name = "pedido_cliente_nombre")),
        @AttributeOverride(name = "cliente.email", column = @Column(name = "pedido_cliente_email")),
        @AttributeOverride(name = "cliente.telefono", column = @Column(name = "pedido_cliente_telefono")),
        @AttributeOverride(name = "cliente.direccion.calle", column = @Column(name = "pedido_cliente_direccion_calle")),
        @AttributeOverride(name = "cliente.direccion.ciudad", column = @Column(name = "pedido_cliente_direccion_ciudad")),
        @AttributeOverride(name = "cliente.direccion.codigoPostal", column = @Column(name = "pedido_cliente_direccion_codigo_postal")),
        @AttributeOverride(name = "cliente.direccion.pais", column = @Column(name = "pedido_cliente_direccion_pais")),
        @AttributeOverride(name = "fechaPedido", column = @Column(name = "pedido_fecha_pedido")),
        @AttributeOverride(name = "estado", column = @Column(name = "pedido_estado")),
        @AttributeOverride(name = "total", column = @Column(name = "pedido_total"))
    })
    private TipoPedido pedido;
}