package com.wanyviny.calendar.domain.calendar.service;

import com.wanyviny.calendar.domain.calendar.dto.CalendarDto;
import com.wanyviny.calendar.domain.calendar.repository.CalendarRepository;
import com.wanyviny.calendar.domain.user.entity.User;
import com.wanyviny.calendar.domain.user.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class CalendarServiceImpl implements CalendarService {

    private final CalendarRepository calendarRepository;
    private final UserRepository userRepository;

    @Override
    public void postSchdule(Long id, CalendarDto.setSchedule schedule) {
        User user = userRepository.findById(id).orElseThrow(
                () -> new IllegalArgumentException("ID에 해당하는 유저가 없습니다.")
        );

        calendarRepository.save(schedule.dtoToEntity(user));
    }
}
