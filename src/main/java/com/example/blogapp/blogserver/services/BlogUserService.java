package com.example.blogapp.blogserver.services;

import com.example.blogapp.blogserver.models.BlogUser;
import com.example.blogapp.blogserver.repositories.BlogUserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.List;
import java.util.Optional;

@Service("blogUserService")
public class BlogUserService
{
    @Autowired
    private BlogUserRepository blogUserRepository;

    public BlogUser findByEmailId(String emailId) {
        return blogUserRepository.findByEmailId(emailId);
    }

    public List<BlogUser> findAll() {
        return blogUserRepository.findAll();
    }

    public BlogUser saveBlogUser(BlogUser blogUser) {
        return blogUserRepository.save(blogUser);
    }

    public BlogUser findById(Long id) {
        Optional<BlogUser> optionalUser = blogUserRepository.findById(id);
        if (optionalUser.isPresent())
            return (BlogUser) optionalUser.get();
        return null;
    }

    public BlogUser updateBlogUser(BlogUser blogUser, Long id) {
        BlogUser currUser = blogUserRepository.findById(id).orElse(null);
        if (null != currUser) {
            currUser.setUserId(blogUser.getUserId());
            currUser.setEmailId(blogUser.getEmailId());
        }
        final BlogUser updUser = blogUserRepository.save(currUser);
        return updUser;
    }

    public Boolean deleteBlogUser(Long id) {
        BlogUser currUser = blogUserRepository.findById(id).orElse(null);
        if (null != currUser) {
            blogUserRepository.delete(currUser);
            return true;
        }
        return false;
    }
}