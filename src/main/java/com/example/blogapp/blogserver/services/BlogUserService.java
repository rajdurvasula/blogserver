package com.example.blogapp.blogserver.services;

import com.example.blogapp.blogserver.models.BlogUser;
import com.example.blogapp.blogserver.repositories.BlogUserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.List;
import java.util.Optional;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

@Service("blogUserService")
public class BlogUserService
{
    @Autowired
    private BlogUserRepository blogUserRepository;

    private Logger logger = LoggerFactory.getLogger("BlogUserservice");

    public BlogUser findByEmailId(String emailId) {
        logger.info("Find BlogUser by Email Id: {0}", new Object[] { emailId });
        return blogUserRepository.findByEmailId(emailId);
    }

    public List<BlogUser> findAll() {
        return blogUserRepository.findAll();
    }

    public BlogUser saveBlogUser(BlogUser blogUser) {
        logger.info("Saving BlogUser ..");
        return blogUserRepository.save(blogUser);
    }

    public BlogUser findById(Long id) {
        logger.info("Find BlogUser by Id: {0}", new Object[] { id });
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
        logger.info("Updated BlogUser with Id: {0}", new Object[] { id });
        return updUser;
    }

    public Boolean deleteBlogUser(Long id) {
        BlogUser currUser = blogUserRepository.findById(id).orElse(null);
        if (null != currUser) {
            blogUserRepository.delete(currUser);
            logger.info("Deleted BlogUser with Id: {0}", new Object[] { id });
            return true;
        }
        return false;
    }
}
