package com.homework.sysale.repository.physicalStore;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.homework.sysale.model.subclass.physical_store.TiendaFisica;

@Repository
public interface TiendaFisicaRepository extends JpaRepository<TiendaFisica, Long> {
}
