package com.homework.sysale.service.physicalStore;

import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.DefaultTransactionDefinition;

import com.homework.sysale.model.subclass.physical_store.TiendaFisica;
import com.homework.sysale.repository.physicalStore.TiendaFisicaRepository;

@Service
public class TiendaFisicaService {
    
    @Autowired
    private TiendaFisicaRepository repository;

    @Autowired
    private PlatformTransactionManager transactionManager;
    
    public List<TiendaFisica> findAll() {
        return repository.findAll();
    }
    
    public Optional<TiendaFisica> findById(Long id) {
        return repository.findById(id);
    }
    
    /**
     * Guarda un pedido físico usando una transacción programática.
     * Demuestra BEGIN/COMMIT/ROLLBACK a través de código.
     * Si la tienda tiene un pedido, se registra de manera transaccional.
     */
    public TiendaFisica save(TiendaFisica tienda) {
        // Usar transacción programática para operaciones críticas
        DefaultTransactionDefinition def = new DefaultTransactionDefinition();
        TransactionStatus status = transactionManager.getTransaction(def);
        
        try {
            // BEGIN - inicia la transacción
            System.out.println("[TRANSACCIÓN] BEGIN - Iniciando registro de tienda física");
            
            // Guardar la tienda (puede incluir pedido)
            TiendaFisica saved = repository.save(tienda);
            
            // Si tiene pedido, registrar log de la operación
            if (saved.getPedido() != null) {
                System.out.println("[TRANSACCIÓN] Pedido registrado para tienda ID: " + saved.getId());
                System.out.println("[TRANSACCIÓN] Total del pedido: " + saved.getPedido().getTotal());
            }
            
            // COMMIT - confirma la transacción
            transactionManager.commit(status);
            System.out.println("[TRANSACCIÓN] COMMIT - Tienda física guardada exitosamente");
            
            return saved;
        } catch (RuntimeException ex) {
            // ROLLBACK - revierte la transacción en caso de error
            transactionManager.rollback(status);
            System.err.println("[TRANSACCIÓN] ROLLBACK - Error al guardar tienda: " + ex.getMessage());
            throw ex;
        }
    }
    
    public TiendaFisica update(Long id, TiendaFisica tiendaDetails) {
        TiendaFisica tienda = repository.findById(id)
            .orElseThrow(() -> new RuntimeException("Tienda Fisica no encontrada con id: " + id));
        
        tienda.setHorarioAtencion(tiendaDetails.getHorarioAtencion());
        tienda.setNumeroEmpleados(tiendaDetails.getNumeroEmpleados());
        tienda.setPedido(tiendaDetails.getPedido());
        
        return repository.save(tienda);
    }
    
    public void deleteById(Long id) {
        repository.deleteById(id);
    }
}
