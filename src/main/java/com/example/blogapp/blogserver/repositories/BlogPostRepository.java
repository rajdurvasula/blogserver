package com.example.blogapp.blogserver.repositories;

import com.example.blogapp.blogserver.models.BlogPost;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import java.util.List;

@Repository("blogPostRepository")
public interface BlogPostRepository extends JpaRepository<BlogPost, Long> {
    @Query("select bp from BlogPost bp where bp.blogUser = :user_id")
    List<BlogPost> findByBlogUser(@Param("user_id") Long id);
}