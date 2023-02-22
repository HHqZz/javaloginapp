FROM tomcat:latest

MAINTAINER Constantin

COPY ./webapp.war /usr/local/tomcat/webapps
