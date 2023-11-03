package com.wanyviny.promise.domain.vote.repository;

import com.wanyviny.promise.domain.vote.entity.Vote;
import org.springframework.data.mongodb.repository.MongoRepository;

public interface VoteRepository extends MongoRepository<Vote, String> {

}
