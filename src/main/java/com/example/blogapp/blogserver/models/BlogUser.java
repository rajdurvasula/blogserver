package com.example.blogapp.blogserver.models;

import java.io.Serializable;
import javax.persistence.*;
import javax.validation.constraints.Email;
import javax.validation.constraints.NotNull;
import lombok.Data;

@Data
@Entity
@Table(name = "blog_users")
public class BlogUser implements Serializable
{

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private Long id;

    @Column(name = "user_id")
    @NotNull
    private String userId;

    @Column(name = "email_id")
    @NotNull
    @Email(message = "* Enter Valid Email Address")
    private String emailId;
}