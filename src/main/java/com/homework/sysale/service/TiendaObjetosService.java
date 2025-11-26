package com.homework.sysale.service;

import com.homework.sysale.model.superclass.TiendaObjetos;
import com.homework.sysale.repository.TiendaObjetosRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class TiendaObjetosService {
    
    private final TiendaObjetosRepository repository;
    
    public List<TiendaObjetos> findAll() {
        return repository.findAll();
    }
    
    public Optional<TiendaObjetos> findById(Long id) {
        return repository.findById(id);
    }
    
    public TiendaObjetos save(TiendaObjetos tiendaObjetos) {
        return repository.save(tiendaObjetos);
    }
    
    public TiendaObjetos update(Long id, TiendaObjetos tiendaObjetos) {
        if (repository.existsById(id)) {
            tiendaObjetos.setId(id);
            return repository.save(tiendaObjetos);
        }
        return null;
    }
    
    public boolean deleteById(Long id) {
        if (repository.existsById(id)) {
            repository.deleteById(id);
            return true;
        }
        return false;
    }
}