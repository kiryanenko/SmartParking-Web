FROM ruby:2.3.1
MAINTAINER Kiryanenko Alexander <KiryanenkoAV@gmail.com>

RUN apt-get update &&\
    apt-get install -y \
        build-essential \
        nodejs \
        npm \
        postgresql-contrib \
        git &&\
    npm install yarn -g

RUN mkdir /app
WORKDIR /app

# Setting env up
ENV RAILS_ENV 'production'
ENV RAKE_ENV 'production'

COPY Gemfile ./
RUN bundle install --jobs 20

COPY . .

RUN bundle exec rake assets:precompile

EXPOSE 3000

CMD rails db:migrate && bundle exec puma -C config/puma.rb
