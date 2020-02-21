FROM ruby:slim-buster as rubybase

# Gets the latest for ruby for this architecture
# Must run on ARM (RPI)

# Includes bundler

# Creates a local environment variable for later use in the Dockerfile
ENV APP_HOME /app  
RUN mkdir $APP_HOME
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

CMD ruby hello.rb

