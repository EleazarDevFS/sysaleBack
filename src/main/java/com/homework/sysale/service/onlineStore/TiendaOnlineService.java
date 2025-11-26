package com.homework.sysale.service.onlineStore;

import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.homework.sysale.model.subclass.online_store.TiendaOnline;
import com.homework.sysale.repository.onlineStore.TiendaOnlineRepository;

@Service
public class TiendaOnlineService {
    
    @Autowired
    private TiendaOnlineRepository repository;
    
    public List<TiendaOnline> findAll() {
        return repository.findAll();
    }
    
    public Optional<TiendaOnline> findById(Long id) {
        return repository.findById(id);
    }
    
    public TiendaOnline save(TiendaOnline tienda) {
        return repository.save(tienda);
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
