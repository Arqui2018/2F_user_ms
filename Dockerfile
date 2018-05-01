FROM ruby:2.3

RUN mkdir /user_ms
WORKDIR /user_ms

ADD Gemfile /user_ms/Gemfile
ADD Gemfile.lock /user_ms/Gemfile.lock

RUN bundle install
ADD . /user_ms

EXPOSE 4001
