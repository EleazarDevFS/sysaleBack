package com.homework.sysale.controller.physicalStore;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.homework.sysale.model.subclass.physical_store.TiendaFisica;
import com.homework.sysale.service.physicalStore.TiendaFisicaService;

@RestController
@RequestMapping("/api/tienda/physical")
@CrossOrigin(origins = "*")
public class TiendaFisicaController {
    
    @Autowired
    private TiendaFisicaService service;
    
    @GetMapping
    public ResponseEntity<List<TiendaFisica>> getAllTiendasFisicas() {
        return ResponseEntity.ok(service.findAll());
    }
    
    @GetMapping("/{id}")
    public ResponseEntity<TiendaFisica> getTiendaFisicaById(@PathVariable Long id) {
        return service.findById(id)
            .map(ResponseEntity::ok)
            .orElse(ResponseEntity.notFound().build());
    }
    
    @PostMapping
    public ResponseEntity<TiendaFisica> createTiendaFisica(@RequestBody TiendaFisica tienda) {
        return ResponseEntity.status(HttpStatus.CREATED).body(service.save(tienda));
    }
    
    @PutMapping("/{id}")
    public ResponseEntity<TiendaFisica> updateTiendaFisica(
            @PathVariable Long id, 
            @RequestBody TiendaFisica tienda) {
        try {
            return ResponseEntity.ok(service.update(id, tienda));
        } catch (RuntimeException e) {
            return ResponseEntity.notFound().build();
        }
    }
    
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteTiendaFisica(@PathVariable Long id) {
        service.deleteById(id);
        return ResponseEntity.noContent().build();
    }
}
