FROM ruby:2.7.1
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client
WORKDIR /repo
COPY Gemfile /repo/Gemfile
COPY Gemfile.lock /repo/Gemfile.lock
RUN bundle install
