# README

### User Microservice
This microservice is the manager of authentication functionality. It is supported on ruby:2.3.
Its database is MySQL and the connector is mysql2.

Post /sessions  => creates a new session(sign in). Email and password are needed
Delete /sessions/:authentication_token => Eliminates the current_session(sign out)
Get /sessions/:authentication_token => gets the information of the current_user