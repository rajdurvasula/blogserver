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
public class BlogUserController
{
    @Autowired
    private BlogUserService userService;
    @Autowired
    private BlogPostService postService;

    @GetMapping("/blog_users")
    public List<BlogUser> all() {
        return userService.findAll();
    }

    @PostMapping("/blog_users")
    public ResponseEntity<BlogUser> createUser(@Valid @RequestBody BlogUser user) {
        return ResponseEntity.ok(userService.saveBlogUser(user));
    }

    @GetMapping("/blog_users/{id}/blog_posts")
    public List<BlogPost> findByUser(@PathVariable(value = "id") Long id) {
        return postService.findByBlogUser(id);
    }

    @PutMapping("/blog_users/{id}")
    public ResponseEntity<BlogUser> updateUser(@Valid @RequestBody BlogUser user, @PathVariable(value = "id") Long id) {
        return ResponseEntity.ok(userService.updateBlogUser(user, id));
    }

    @DeleteMapping("/blog_users/{id}")
    public ResponseEntity<?> deleteUser(@PathVariable(value = "id") Long id) {
        Map<String, String> response = new HashMap<String, String>();
        if (userService.deleteBlogUser(id)) {
            response.put("status", "success");
            response.put("message", "Blog User deleted.");
        } else {
            response.put("status", "failed");
            response.put("message", "Error while deleting Blog User !");
        }
        return ResponseEntity.status(500).body(response);
    }

    @PostMapping("/blog_users/{id}/blog_posts")
    public ResponseEntity<?> createPost(@PathVariable(value="id") Long userId, @Valid @RequestBody BlogPost blogPost) {
        Map<String, String> response = new HashMap<String, String>();
        BlogUser blogUser = userService.findById(userId);
        if (null != blogUser) {
            blogPost.setBlogUser(blogUser);
            return ResponseEntity.ok(postService.savePost(blogPost));
        } else {
            response.put("status", "failed");
            response.put("message", "Blog User "+userId+" not found !");
            return ResponseEntity.status(500).body(response);
        }
    }

    @PutMapping("/blog_users/{id}/blog_posts/{post_id}")
    public ResponseEntity<?> updatePost(@PathVariable(value="id") Long userId, @PathVariable(value="post_id") Long postId, @Valid @RequestBody BlogPost blogPost) {
        Map<String, String> response = new HashMap<String, String>();
        BlogUser blogUser = userService.findById(userId);
        if (null != blogUser) {
            BlogPost currPost = postService.findById(postId);
            if (null != currPost) {
                return ResponseEntity.ok(postService.updatePost(blogPost, userId, postId));
            } else {
                response.put("status", "failed");
                response.put("message", "Blog Post "+postId+" not found !");
            }
        } else {
            response.put("status", "failed");
            response.put("message", "Blog User "+userId+" not found !");           
        }
        return ResponseEntity.status(500).body(response);
    }

}