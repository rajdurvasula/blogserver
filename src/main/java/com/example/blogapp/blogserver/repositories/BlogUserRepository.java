package com.example.blogapp.blogserver.repositories;

import com.example.blogapp.blogserver.models.BlogUser;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository("blogUserRepository")
public interface BlogUserRepository extends JpaRepository<BlogUser, Long> {
    BlogUser findByEmailId(String emailId);
}