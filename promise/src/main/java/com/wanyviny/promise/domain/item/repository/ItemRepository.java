package com.wanyviny.promise.domain.item.repository;

import com.wanyviny.promise.domain.item.entity.Item;
import com.wanyviny.promise.domain.item.entity.ItemType;
import org.springframework.data.jpa.repository.JpaRepository;

public interface ItemRepository extends JpaRepository<Item, Long> {

    boolean existsByRoom_IdAndItemType(Long roomId, ItemType itemType);
}
