package com.example.blogapp.blogserver.services;

import com.example.blogapp.blogserver.models.BlogUser;
import com.example.blogapp.blogserver.models.BlogPost;
import com.example.blogapp.blogserver.repositories.BlogUserRepository;
import com.example.blogapp.blogserver.repositories.BlogPostRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@Service("blogPostService")
public class BlogPostService
{
    @Autowired
    private BlogUserRepository blogUserRepository;
    @Autowired
    private BlogPostRepository blogPostRepository;

    public List<BlogPost> findAll() {
        return blogPostRepository.findAll();
    }

    public BlogPost findById(Long id) {
        Optional<BlogPost> optionalPost = blogPostRepository.findById(id);
        if (optionalPost.isPresent())
            return (BlogPost) optionalPost.get();
        return null;
    }

    public List<BlogPost> findByBlogUser(Long userId) {
        BlogUser blogUser = blogUserRepository.findById(userId).orElse(null);
        List<BlogPost> blogPosts = new ArrayList<BlogPost>();
        if (null != blogUser) {
            blogPosts = blogPostRepository.findByBlogUser(blogUser.getId());
        }
        return blogPosts;
    }

    public BlogPost savePost(BlogPost blogPost) {
        return blogPostRepository.save(blogPost);
    }

    public BlogPost updatePost(BlogPost blogPost, Long userId, Long postId) {
        BlogPost currPost = blogPostRepository.findById(userId).orElse(null);
        if (null != currPost) {
            currPost.setTitle(blogPost.getTitle());
            currPost.setDescription(blogPost.getDescription());
            currPost.setPubDate(blogPost.getPubDate());
            BlogUser blogUser = blogUserRepository.findById(blogPost.getBlogUser().getId()).orElse(null);
            if (null != blogUser) {
                currPost.setBlogUser(blogUser);
            }
        }
        final BlogPost updPost = blogPostRepository.save(currPost);
        return updPost;
    }

    public Boolean deletePost(Long id) {
        BlogPost currPost = blogPostRepository.findById(id).orElse(null);
        if (null != currPost) {
            blogPostRepository.delete(currPost);
            return true;
        }
        return false;
    }
}
