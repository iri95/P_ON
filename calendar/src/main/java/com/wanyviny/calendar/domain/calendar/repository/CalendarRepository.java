package com.wanyviny.calendar.domain.calendar.repository;

import com.wanyviny.calendar.domain.calendar.entity.Calendar;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Repository
public interface CalendarRepository extends JpaRepository<Calendar, Long> {
    List<Calendar> findByUserId_id(Long id);

    Optional<Calendar> findByUserId_idAndId(Long id, Long calendarId);

    @Transactional
    void deleteByUserId_IdAndId(Long id, Long calendarId);

    List<Calendar> findByUserId_Id(Long userId);

    @Transactional
    @Query("DELETE FROM Calendar c where c.userId.id = :id AND c.id in :deleteList")
    void deleteByUserId_IdAndIdList(Long id, List<Long> deleteList);
}
