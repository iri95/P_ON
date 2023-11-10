package com.wanyviny.promise.domain.item.service;

import com.wanyviny.promise.domain.item.dto.ItemRequest;
import com.wanyviny.promise.domain.item.dto.ItemResponse;

public interface ItemService {

    ItemResponse.Create createItem(Long userId, Long roomId, ItemRequest.Create request);
    ItemResponse.Modify modifyItem(Long userId, Long roomId, ItemRequest.Modify request);
}
