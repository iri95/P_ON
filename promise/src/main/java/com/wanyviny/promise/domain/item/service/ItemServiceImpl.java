package com.wanyviny.promise.domain.item.service;

import com.wanyviny.promise.domain.item.dto.ItemRequest;
import com.wanyviny.promise.domain.item.dto.ItemRequest.Create;
import com.wanyviny.promise.domain.item.dto.ItemResponse;
import com.wanyviny.promise.domain.item.dto.ItemResponse.Modify;
import com.wanyviny.promise.domain.item.entity.Item;
import com.wanyviny.promise.domain.item.entity.ItemType;
import com.wanyviny.promise.domain.item.repository.ItemRepository;
import com.wanyviny.promise.domain.room.entity.Room;
import com.wanyviny.promise.domain.room.repository.RoomRepository;
import com.wanyviny.promise.domain.room.repository.UserRoomRepository;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class ItemServiceImpl implements ItemService {

    private final ModelMapper modelMapper;
    private final ItemRepository itemRepository;
    private final RoomRepository roomRepository;
    private final UserRoomRepository userRoomRepository;

    @Override
    @Transactional
    public ItemResponse.Create createItem(Long userId, Long roomId, Create request) {

        Room room = roomRepository.findById(roomId).orElseThrow();

        room.setUserId(userId);
        room.setDeadDate(request.getDeadDate());
        room.setDeadTime(request.getDeadTime());
        room.setAnonymous(request.isAnonymous());
        room.setMultipleChoice(request.isMultipleChoice());

        ItemResponse.Create response = modelMapper.map(room, ItemResponse.Create.class);
        response.setUserCount(userRoomRepository.countAllByRoom_Id(room.getId()));

        if (request.getDate() != null) {

            request.getDate()
                    .forEach(date -> {
                        Item item = Item.builder()
                                .itemType(ItemType.DATE)
                                .date(date)
                                .room(room)
                                .build();

                        itemRepository.save(item);
                    });

            response.setDate(true);
        }

        if (request.getTime() != null) {

            request.getTime()
                    .forEach(time -> {
                        Item item = Item.builder()
                                .itemType(ItemType.TIME)
                                .time(time)
                                .room(room)
                                .build();

                        itemRepository.save(item);
                    });

            response.setTime(true);
        }

        if (request.getLocation() != null) {

            request.getLocation()
                    .forEach(location -> {
                        Item item = Item.builder()
                                .itemType(ItemType.LOCATION)
                                .location(location.get("location"))
                                .lat(location.get("lat"))
                                .lng(location.get("lng"))
                                .room(room)
                                .build();

                        itemRepository.save(item);
                    });

            response.setLocation(true);
        }

        return response;
    }

    @Override
    public Modify modifyItem(Long userId, Long roomId, ItemRequest.Modify request) {

        Room room = roomRepository.findById(roomId).orElseThrow();

        room.setUserId(userId);
        room.setDeadDate(request.getDeadDate());
        room.setDeadTime(request.getDeadTime());
        room.setAnonymous(request.isAnonymous());
        room.setMultipleChoice(request.isMultipleChoice());

        ItemResponse.Modify response = modelMapper.map(room, ItemResponse.Modify.class);
        response.setUserCount(userRoomRepository.countAllByRoom_Id(room.getId()));
        itemRepository.deleteAllByRoomId(roomId);

        if (request.getDate() != null) {

            request.getDate()
                    .forEach(date -> {
                        Item item = Item.builder()
                                .itemType(ItemType.DATE)
                                .date(date)
                                .room(room)
                                .build();

                        itemRepository.save(item);
                    });

            response.setDate(true);

        }

        if (request.getTime() != null) {

            request.getTime()
                    .forEach(time -> {
                        Item item = Item.builder()
                                .itemType(ItemType.TIME)
                                .time(time)
                                .room(room)
                                .build();

                        itemRepository.save(item);
                    });

            response.setTime(true);
        }

        if (request.getLocation() != null) {

            request.getLocation()
                    .forEach(location -> {
                        Item item = Item.builder()
                                .itemType(ItemType.LOCATION)
                                .location(location.get("location"))
                                .lat(location.get("lat"))
                                .lng(location.get("lng"))
                                .room(room)
                                .build();

                        itemRepository.save(item);
                    });

            response.setLocation(true);
        }

        return response;
    }
}
