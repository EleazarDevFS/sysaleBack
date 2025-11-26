package com.homework.sysale.controller.onlineStore;

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

import com.homework.sysale.model.subclass.online_store.TiendaOnline;
import com.homework.sysale.service.onlineStore.TiendaOnlineService;

@RestController
@RequestMapping("/api/tienda/online")
@CrossOrigin(origins = "*")
public class TiendaOnlineController {
    
    @Autowired
    private TiendaOnlineService service;
    
    @GetMapping
    public ResponseEntity<List<TiendaOnline>> getAllTiendasOnline() {
        return ResponseEntity.ok(service.findAll());
    }
    
    @GetMapping("/{id}")
    public ResponseEntity<TiendaOnline> getTiendaOnlineById(@PathVariable Long id) {
        return service.findById(id)
            .map(ResponseEntity::ok)
            .orElse(ResponseEntity.notFound().build());
    }
    
    @PostMapping
    public ResponseEntity<TiendaOnline> createTiendaOnline(@RequestBody TiendaOnline tienda) {
        return ResponseEntity.status(HttpStatus.CREATED).body(service.save(tienda));
    }
    
    @PutMapping("/{id}")
    public ResponseEntity<TiendaOnline> updateTiendaOnline(
            @PathVariable Long id, 
            @RequestBody TiendaOnline tienda) {
        try {
            return ResponseEntity.ok(service.update(id, tienda));
        } catch (RuntimeException e) {
            return ResponseEntity.notFound().build();
        }
    }
    
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteTiendaOnline(@PathVariable Long id) {
        service.deleteById(id);
        return ResponseEntity.noContent().build();
    }
}
