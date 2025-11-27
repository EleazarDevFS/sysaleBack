package com.homework.sysale.service.onlineStore;

import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.DefaultTransactionDefinition;

import com.homework.sysale.model.subclass.online_store.TiendaOnline;
import com.homework.sysale.repository.onlineStore.TiendaOnlineRepository;

@Service
public class TiendaOnlineService {
    
    @Autowired
    private TiendaOnlineRepository repository;

    @Autowired
    private PlatformTransactionManager transactionManager;
    
    public List<TiendaOnline> findAll() {
        return repository.findAll();
    }
    
    public Optional<TiendaOnline> findById(Long id) {
        return repository.findById(id);
    }
    
    /**
     * Guarda un pedido online usando una transacción programática.
     * Demuestra BEGIN/COMMIT/ROLLBACK a través de código.
     * Si la tienda tiene un pedido, se registra de manera transaccional.
     */
    public TiendaOnline save(TiendaOnline tienda) {
        // Usar transacción programática para operaciones críticas
        DefaultTransactionDefinition def = new DefaultTransactionDefinition();
        TransactionStatus status = transactionManager.getTransaction(def);
        
        try {
            // BEGIN - inicia la transacción
            System.out.println("[TRANSACCIÓN] BEGIN - Iniciando registro de tienda online");
            
            // Guardar la tienda (puede incluir pedido)
            TiendaOnline saved = repository.save(tienda);
            
            // Si tiene pedido, registrar log de la operación
            if (saved.getPedido() != null) {
                System.out.println("[TRANSACCIÓN] Pedido registrado para tienda ID: " + saved.getId());
                System.out.println("[TRANSACCIÓN] Total del pedido: " + saved.getPedido().getTotal());
            }
            
            // COMMIT - confirma la transacción
            transactionManager.commit(status);
            System.out.println("[TRANSACCIÓN] COMMIT - Tienda online guardada exitosamente");
            
            return saved;
        } catch (RuntimeException ex) {
            // ROLLBACK - revierte la transacción en caso de error
            transactionManager.rollback(status);
            System.err.println("[TRANSACCIÓN] ROLLBACK - Error al guardar tienda: " + ex.getMessage());
            throw ex;
        }
    }
    
    public TiendaOnline update(Long id, TiendaOnline tiendaDetails) {
        TiendaOnline tienda = repository.findById(id)
            .orElseThrow(() -> new RuntimeException("Tienda Online no encontrada con id: " + id));
        
        tienda.setUrlWeb(tiendaDetails.getUrlWeb());
        tienda.setEnvioGratis(tiendaDetails.getEnvioGratis());
        tienda.setPedido(tiendaDetails.getPedido());
        
        return repository.save(tienda);
    }
    
    public void deleteById(Long id) {
        repository.deleteById(id);
    }
}
