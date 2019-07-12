FROM ruby:2.6-alpine

# With the latest Alpine and latest minor release or Ruby. Can be more precise if needed.
# Includes bundler

ENV APP_HOME /app  
RUN mkdir $APP_HOME
WORKDIR $APP_HOME
ADD Gemfile* $APP_HOME/  

RUN bundle install --verbose


