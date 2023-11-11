package com.wanyviny.promise.domain.vote.dto;

import com.wanyviny.promise.domain.item.entity.Item;
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
    public static class post{
        List<Long> itemList;
    }


//    @Builder
//    @Getter
//    @NoArgsConstructor
//    @AllArgsConstructor
//    public static class get{
//
//    }

    @Builder
    @Getter
    @NoArgsConstructor
    @AllArgsConstructor
    public static class put{
        List<Long> itemList;
        ItemType itemType;

    }

}
