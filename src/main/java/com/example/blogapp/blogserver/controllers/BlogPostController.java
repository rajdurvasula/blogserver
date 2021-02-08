package com.example.blogapp.blogserver.controllers;

import com.example.blogapp.blogserver.models.BlogUser;
import com.example.blogapp.blogserver.models.BlogPost;
import com.example.blogapp.blogserver.services.BlogUserService;
import com.example.blogapp.blogserver.services.BlogPostService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.List;
import java.util.Map;
import java.util.HashMap;
import javax.validation.Valid;

@RestController
@RequestMapping("/api")
public class BlogPostController
{
    @Autowired
    private BlogPostService postService;

    @GetMapping("/blog_posts")
    public List<BlogPost> all() {
        return postService.findAll();
    }

    @DeleteMapping("/blog_posts/{id}")
    public ResponseEntity<?> deletePost(@PathVariable(value = "id") Long id) {
        Map<String, String> response = new HashMap<String, String>();
        if (postService.deletePost(id)) {
            response.put("status", "success");
            response.put("message", "Blog Post deleted.");
        } else {
            response.put("status", "failed");
            response.put("message", "Error while deleting Blog Post !");
        }
        return ResponseEntity.status(500).body(response);
    }

}