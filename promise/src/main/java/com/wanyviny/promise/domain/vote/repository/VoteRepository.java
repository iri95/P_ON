package com.wanyviny.promise.domain.vote.repository;

import com.wanyviny.promise.domain.vote.entity.Vote;
import org.springframework.data.jpa.repository.JpaRepository;

public interface VoteRepository extends JpaRepository<Vote, Long> {

}
