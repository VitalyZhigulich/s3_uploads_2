FROM ruby:3.0.2

RUN apt-get update -qq && apt-get install -y nodejs

ENV RAILS_ROOT /var/www/

RUN mkdir -p $RAILS_ROOT
WORKDIR $RAILS_ROOT
COPY Gemfile* ./

RUN bundle install --jobs 4
COPY . .
