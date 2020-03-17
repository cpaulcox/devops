FROM ruby:slim-buster as rubybase

# Gets the latest for ruby for this architecture
# Must run on ARM (RPI)

# Includes bundler

# Creates a local environment variable for later use in the Dockerfile
ENV APP_HOME /app  
RUN mkdir $APP_HOME
RUN apt update
RUN apt install -y cmake
WORKDIR $APP_HOME
ADD Gemfile* $APP_HOME/  

RUN bundle install --verbose


FROM rubybase

# args with default values override with docker build --build-arg.
# Used later in environment and labels.
ARG buildDate=01-01-1970
ARG builtBy=Anon

# Runtime environment variables available to the application in the container
ENV buildDate=$buildDate
ENV builtBy=$builtBy

# Image labels available from docker inspect
LABEL buildDate=$buildDate
LABEL builtBy="$builtBy"

ADD hello.rb $APP_HOME
ADD config.ru $APP_HOME
# Add TLS self-signed private key and certificate
ADD example.key $APP_HOME
ADD example.crt $APP_HOME
ADD config $APP_HOME/config

#CMD ruby hello.rb
CMD puma config.ru

