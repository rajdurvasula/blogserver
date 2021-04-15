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
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

@Service("blogPostService")
public class BlogPostService
{
    @Autowired
    private BlogUserRepository blogUserRepository;
    @Autowired
    private BlogPostRepository blogPostRepository;
    private Logger logger = LoggerFactory.getLogger("BlogPostService");

    public List<BlogPost> findAll() {
        return blogPostRepository.findAll();
    }

    public BlogPost findById(Long id) {
        logger.info("Find BlogPost by Id: {0}", new Object[] { id });
        Optional<BlogPost> optionalPost = blogPostRepository.findById(id);
        if (optionalPost.isPresent())
            return (BlogPost) optionalPost.get();
        return null;
    }

    public List<BlogPost> findByBlogUser(Long userId) {
        logger.info("Find BlogPost by BlogUser Id: {0}", new Object[] { userId });
        BlogUser blogUser = blogUserRepository.findById(userId).orElse(null);
        List<BlogPost> blogPosts = new ArrayList<BlogPost>();
        if (null != blogUser) {
            blogPosts = blogPostRepository.findByBlogUser(blogUser.getId());
        }
        return blogPosts;
    }

    public BlogPost savePost(BlogPost blogPost) {
        logger.info("Saving BlogPost ..");
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
        logger.info("Updated BlogPost with Id: {0}", new Object[] { postId });
        return updPost;
    }

    public Boolean deletePost(Long id) {
        BlogPost currPost = blogPostRepository.findById(id).orElse(null);
        if (null != currPost) {
            blogPostRepository.delete(currPost);
            logger.info("Deleted BlogPost with Id: {0}", new Object[] { id });
            return true;
        }
        return false;
    }
}
