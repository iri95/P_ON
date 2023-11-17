package com.wanyviny.promise.domain.calendar.repository;

import com.wanyviny.promise.domain.calendar.entity.Calendar;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;



@Repository
public interface CalendarRepository extends JpaRepository<Calendar, Long> {
}

