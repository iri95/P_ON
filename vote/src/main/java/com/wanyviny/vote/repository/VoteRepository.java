package com.wanyviny.vote.repository;

import com.wanyviny.vote.entity.Vote;
import org.springframework.data.mongodb.repository.MongoRepository;

public interface VoteRepository extends MongoRepository<Vote, String> {

}
