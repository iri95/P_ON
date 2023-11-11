package com.wanyviny.promise.domain.vote.repository;

import com.wanyviny.promise.domain.item.entity.ItemType;
import com.wanyviny.promise.domain.vote.entity.Vote;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.transaction.annotation.Transactional;

public interface VoteRepository extends JpaRepository<Vote, Long> {

    @Transactional
    @Modifying
    @Query("DELETE From Vote v where v.user.id = :userId And v.item.itemType = :type And v.item.room in (select r from Room r where r.id = :roomId)")
    void deleteByUser_IdAndItem_TypeAndRoom_Id(Long userId, ItemType type, Long roomId);

}
