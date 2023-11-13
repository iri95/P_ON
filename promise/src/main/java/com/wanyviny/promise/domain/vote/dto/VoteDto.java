package com.wanyviny.promise.domain.vote.dto;

import com.wanyviny.promise.domain.item.entity.ItemType;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.util.List;

public class VoteDto {

    @Builder
    @Getter
    @NoArgsConstructor
    @AllArgsConstructor
    public static class post {
        List<Long> itemList;
    }


    @Builder
    @Getter
    @NoArgsConstructor
    @AllArgsConstructor
    public static class get {
        @Builder.Default
        private boolean doDate = false;
        private boolean doTime = false;
        private boolean doLocation = false;
        private boolean dateComplete = false;
        private boolean timeComplete = false;;
        private boolean locationComplete = false;;
        private List<getDate> dates;
        private List<getTime> times;
        private List<getLocation> locations;

        @Builder
        @Getter
        @NoArgsConstructor
        @AllArgsConstructor
        public static class getDate {
            private Long itemId;
            private String date;
            List<user> users;

        }

        @Builder
        @Getter
        @NoArgsConstructor
        @AllArgsConstructor
        public static class getTime {
            private Long itemId;
            private String time;
            List<user> users;

        }

        @Builder
        @Getter
        @NoArgsConstructor
        @AllArgsConstructor
        public static class getLocation {
            private Long itemId;
            private String location;
            private String lat;
            private String lng;
            List<user> users;

        }

        @Builder
        @Getter
        @NoArgsConstructor
        @AllArgsConstructor
        public static class user {
            private Long id;
            private String nickName;
            private String profileImage;
        }
    }

    @Builder
    @Getter
    @NoArgsConstructor
    @AllArgsConstructor
    public static class put {
        Long roomId;
        ItemType itemType;
        List<Long> itemList;
    }

}
