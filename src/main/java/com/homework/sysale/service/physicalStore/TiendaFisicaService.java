package com.homework.sysale.service.physicalStore;

import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.homework.sysale.model.subclass.physical_store.TiendaFisica;
import com.homework.sysale.repository.physicalStore.TiendaFisicaRepository;

@Service
public class TiendaFisicaService {
    
    @Autowired
    private TiendaFisicaRepository repository;
    
    public List<TiendaFisica> findAll() {
        return repository.findAll();
    }
    
    public Optional<TiendaFisica> findById(Long id) {
        return repository.findById(id);
    }
    
    public TiendaFisica save(TiendaFisica tienda) {
        return repository.save(tienda);
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
