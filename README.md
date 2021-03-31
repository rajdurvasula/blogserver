# blogserver
This is a simple Spring Boot application with JPA,REST API

## Pre-requisites
- Install J2SE 1.8 (latest)
- Install Apache Maven 3.6.x (latest)
- Install MariaDB

## Database setup
- Create Database: blog_db
- Create Application User: appuser
  - Refer to application.properties

## OS Users (Optional)
- Create Application group: appuser
- Create Application user: appuser

## Code
- Clone this Git Repository to appuser HOME directory
 
## Build and Run
```
# cd blogserver
mvn clean package -DskipTests
```

## Limitations
- Server logs are not collected in a Log file
  - Need to implement logging
