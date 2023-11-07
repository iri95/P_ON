package com.wanyviny.vote.service;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.wanyviny.vote.dto.VoteRequest;
import com.wanyviny.vote.dto.VoteResponse;
import com.wanyviny.vote.entity.Vote;
import com.wanyviny.vote.repository.VoteRepository;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class VoteServiceImpl implements VoteService {

    private final ObjectMapper objectMapper;
    private final ModelMapper modelMapper;
    private final VoteRepository voteRepository;

    @Override
    public void createVote(String roomId, VoteRequest request) {

        Vote vote = modelMapper.map(request, Vote.class);
        vote.setId(roomId);
        voteRepository.save(vote);
    }

    @Override
    public VoteResponse findVote(String roomId) {

        VoteResponse response = modelMapper.map(voteRepository.findById(roomId), VoteResponse.class);

        if (response.getDate().size() > 1) {
            String date = String.valueOf(objectMapper.convertValue(response.getDate()
                                    .get("deadLine"), HashMap.class)
                            .get("date"))
                    .substring(0, 10);

            String temp = String.valueOf(objectMapper.convertValue(response.getDate()
                            .get("deadLine"), HashMap.class)
                    .get("time"));

            String time = temp.substring(3);

            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH시 mm분");
            LocalDateTime localDateTime = LocalDateTime.parse(date + " " + time, formatter);

            if (temp.startsWith("오후")) {

                localDateTime = localDateTime.plusHours(12);
            }

            if (localDateTime.compareTo(LocalDateTime.now()) > 0) {
                response.getDate().put("isComplete", "false");

            } else {
                response.getDate().put("isComplete", "true");
            }
        }

        if (response.getTime().size() > 1) {
            String date = String.valueOf(objectMapper.convertValue(response.getTime()
                                    .get("deadLine"), HashMap.class)
                            .get("date"))
                    .substring(0, 10);

            String temp = String.valueOf(objectMapper.convertValue(response.getTime()
                            .get("deadLine"), HashMap.class)
                    .get("time"));

            String time = temp.substring(3);

            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH시 mm분");
            LocalDateTime localDateTime = LocalDateTime.parse(date + " " + time, formatter);

            if (temp.startsWith("오후")) {

                localDateTime = localDateTime.plusHours(12);
            }

            if (localDateTime.compareTo(LocalDateTime.now()) > 0) {
                response.getTime().put("isComplete", "false");

            } else {
                response.getTime().put("isComplete", "true");
            }
        }

        if (response.getLocation().size() > 1) {
            String date = String.valueOf(objectMapper.convertValue(response.getLocation()
                                    .get("deadLine"), HashMap.class)
                            .get("date"))
                    .substring(0, 10);

            String temp = String.valueOf(objectMapper.convertValue(response.getLocation()
                            .get("deadLine"), HashMap.class)
                    .get("time"));

            String time = temp.substring(3);

            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH시 mm분");
            LocalDateTime localDateTime = LocalDateTime.parse(date + " " + time, formatter);

            if (temp.startsWith("오후")) {

                localDateTime = localDateTime.plusHours(12);
            }

            if (localDateTime.compareTo(LocalDateTime.now()) > 0) {
                response.getLocation().put("isComplete", "false");

            } else {
                response.getLocation().put("isComplete", "true");
            }
        }

        return response;
    }

    @Override
    public void modifyVote(String roomId, VoteRequest request) {

        Vote vote = modelMapper.map(request, Vote.class);
        vote.setId(roomId);
        voteRepository.save(vote);
    }
}
