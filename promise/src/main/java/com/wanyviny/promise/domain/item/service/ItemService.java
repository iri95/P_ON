package com.wanyviny.promise.domain.item.service;

import com.wanyviny.promise.domain.item.dto.ItemRequest;
import com.wanyviny.promise.domain.item.dto.ItemResponse;
import com.wanyviny.promise.domain.item.entity.ItemType;

public interface ItemService {

    ItemResponse.Create createItem(Long userId, Long roomId, ItemRequest.Create request);
    ItemResponse.Find findItem(Long roomId);
    ItemResponse.Modify modifyItem(Long userId, Long roomId, ItemRequest.Modify request);
    void deleteItemType(Long roomId, ItemType itemType);

    void putItemType(Long roomId, ItemType itemType);
}
