package com.homework.sysale.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.homework.sysale.model.superclass.TiendaObjetos;

@Repository
public interface TiendaObjetosRepository extends JpaRepository<TiendaObjetos, Long> {
}
