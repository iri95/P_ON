package com.wanyviny.user.user.repository;

import com.wanyviny.user.user.entity.USERS;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface UserRepository extends JpaRepository<USERS, Long> {

}
