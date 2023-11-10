package com.wanyviny.promise.domain.item.service;

import com.wanyviny.promise.domain.item.dto.ItemRequest;
import com.wanyviny.promise.domain.item.dto.ItemRequest.Create;
import com.wanyviny.promise.domain.item.dto.ItemResponse;
import com.wanyviny.promise.domain.item.dto.ItemResponse.Find;
import com.wanyviny.promise.domain.item.dto.ItemResponse.Modify;
import com.wanyviny.promise.domain.item.entity.Item;
import com.wanyviny.promise.domain.item.entity.ItemType;
import com.wanyviny.promise.domain.item.repository.ItemRepository;
import com.wanyviny.promise.domain.room.entity.Room;
import com.wanyviny.promise.domain.room.repository.RoomRepository;
import com.wanyviny.promise.domain.room.repository.UserRoomRepository;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
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

        response.setComplete(isComplete(room.getDeadDate(), room.getDeadTime()));
        return response;
    }

    @Override
    public Find findItem(Long roomId) {

        List<Item> items = itemRepository.findAllByRoomId(roomId);
        Room room = roomRepository.findById(roomId).orElseThrow();
        ItemResponse.Find response = modelMapper.map(room, ItemResponse.Find.class);

        List<String> date = new ArrayList<>();
        List<String> time = new ArrayList<>();
        List<Map<String, String>> locations = new ArrayList<>();

        items.forEach(item -> {
            if (item.getItemType().equals(ItemType.DATE)) {

                date.add(item.getDate());

            } else if (item.getItemType().equals(ItemType.TIME)) {

                time.add(item.getTime());

            } else {

                Map<String, String> location = new HashMap<>();
                location.put("location", item.getLocation());
                location.put("lng", item.getLng());
                location.put("lat", item.getLat());
                locations.add(location);
            }
        });

        response.setDate(date);
        response.setTime(time);
        response.setLocation(locations);

        return response;
    }

    @Override
    @Transactional
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

        response.setComplete(isComplete(room.getDeadDate(), room.getDeadTime()));
        return response;
    }

    private boolean isComplete(String deadDate, String deadTime) {

        String date = deadDate.substring(0, 10);
        String time = deadTime.substring(3);

        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH시 mm분");
        LocalDateTime localDateTime = LocalDateTime.parse(date + " " + time, formatter);

        if (deadTime.startsWith("오후")) {

            localDateTime = localDateTime.plusHours(12);
        }

//        return localDateTime.compareTo(LocalDateTime.now()) > 0 ? false : true;
        return !localDateTime.isAfter(LocalDateTime.now());
    }
}
