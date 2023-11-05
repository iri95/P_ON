package com.wanyviny.calendar.domain.calendar.dto;

import com.fasterxml.jackson.annotation.JsonInclude;
import com.wanyviny.calendar.domain.calendar.entity.Calendar;
import com.wanyviny.calendar.domain.user.entity.User;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.util.Date;
import java.util.List;

@Builder
@Getter
@AllArgsConstructor
@NoArgsConstructor
public class CalendarDto {
    private Long id;
    private List<getSchedule> scheduleList;

    @Builder
    @Getter
    @AllArgsConstructor
    @NoArgsConstructor
    @JsonInclude(JsonInclude.Include.NON_NULL)
    public static class getSchedule {
        private Long calendarId;
        private String title;
        private String content;
        private Date startDate;
        private Date endDate;
        private String place;
    }

    @Builder
    @Getter
    @AllArgsConstructor
    @NoArgsConstructor
    public static class setSchedule{
        private String title;
        private String content;
        private Date startDate;
        private Date endDate;
        private String place;

        public Calendar dtoToEntity(User user){
            return Calendar.builder()
                    .userId(user)
                    .title(title)
                    .content(content)
                    .startDate(startDate)
                    .endDate(endDate)
                    .place(place)
                    .build();
        }
    }
}
