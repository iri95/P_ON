package com.wanyviny.alarm.domain.user.repository;

import com.wanyviny.alarm.domain.user.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface UserRepository extends JpaRepository<User, Long> {

    Optional<User> findBySocialId(String socialId);

    List<User> findByNicknameContaining(String keyword);
}
