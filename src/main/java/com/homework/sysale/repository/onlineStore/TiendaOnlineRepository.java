package com.homework.sysale.repository.onlineStore;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.homework.sysale.model.subclass.online_store.TiendaOnline;

@Repository
public interface TiendaOnlineRepository extends JpaRepository<TiendaOnline, Long> {
}
