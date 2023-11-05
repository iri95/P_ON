package com.wanyviny.calendar.domain.calendar.repository;

import com.wanyviny.calendar.domain.calendar.entity.Calendar;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface CalendarRepository extends JpaRepository<Calendar, Long> {
    List<Calendar> findByUserId_id(Long id);

    Optional<Calendar> findByUserId_idAndId(Long id, Long calendarId);
}
