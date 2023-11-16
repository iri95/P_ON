package com.wanyviny.calendar.global.kafka.dto;

import com.wanyviny.calendar.domain.CALENDAR_TYPE;
import com.wanyviny.calendar.domain.calendar.dto.CalendarDto;
import com.wanyviny.calendar.domain.user.entity.User;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

@Builder
@Getter
@NoArgsConstructor
@AllArgsConstructor
public class KafkaCalendarDto {
    private Long userId;
    private Cal cal;

    @Builder
    @Getter
    @NoArgsConstructor
    @AllArgsConstructor
    public static class Cal {
        private String calendar_title;
        private String calendar_place;
        private String calendar_start_date;
        private String calendar_end_date;
    }

    public CalendarDto.setSchedule kafkaToSet() throws ParseException {

        // date 형 변환
        cal.calendar_start_date = cal.calendar_start_date + " 00:00:00";
        cal.calendar_end_date = cal.calendar_end_date + " 23:59:59";
        SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        Date startDate = new Date();
        Date endDate = new Date();
        try {
            format.parse(cal.calendar_end_date);
            format.parse(cal.calendar_start_date);
            return CalendarDto.setSchedule.builder()
                    .title(cal.calendar_title)
                    .content(cal.calendar_title)
                    .place(cal.calendar_place)
                    .type(CALENDAR_TYPE.SCHEDULE)
                    .startDate(startDate)
                    .endDate(endDate)
                    .build();
        } catch (ParseException e) {
            return CalendarDto.setSchedule.builder()
                    .title(cal.calendar_title)
                    .content(cal.calendar_title)
                    .place(cal.calendar_place)
                    .type(CALENDAR_TYPE.SCHEDULE)
                    .startDate(startDate)
                    .endDate(endDate)
                    .build();
        }
    }
}
