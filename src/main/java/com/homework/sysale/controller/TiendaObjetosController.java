package com.homework.sysale.controller;

import com.homework.sysale.model.superclass.TiendaObjetos;
import com.homework.sysale.service.TiendaObjetosService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/api/tienda")
@RequiredArgsConstructor
public class TiendaObjetosController {
    
    private final TiendaObjetosService service;
    
    @GetMapping
    public List<TiendaObjetos> getAll() {
        System.out.println(service.findAll());
        return service.findAll();
    }
    
    @GetMapping("/{id}")
    public ResponseEntity<TiendaObjetos> getById(@PathVariable Long id) {
        Optional<TiendaObjetos> tiendaObjetos = service.findById(id);
        return tiendaObjetos.map(ResponseEntity::ok)
                           .orElse(ResponseEntity.notFound().build());
    }
    
    // POST, PUT y DELETE no están disponibles para la clase base abstracta
    // Usa /api/tienda/online o /api/tienda/physical para crear instancias específicas
}