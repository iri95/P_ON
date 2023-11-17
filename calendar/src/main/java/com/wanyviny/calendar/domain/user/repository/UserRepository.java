package com.wanyviny.calendar.domain.user.repository;

import com.wanyviny.calendar.domain.PRIVACY;
import com.wanyviny.calendar.domain.user.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

@Repository
public interface UserRepository extends JpaRepository<User, Long> {
    @Query("SELECT u.privacy FROM User u where u.id = :userId")
    PRIVACY findPrivacyById(Long userId);
}
