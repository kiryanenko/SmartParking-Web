FROM ruby:2.3
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

COPY Gemfile ./
RUN bundle install --jobs 20

COPY . .

# Setting env up
ENV RAILS_ENV 'production'
ENV RAKE_ENV 'production'
ENV SECRET_KEY_BASE $(rake secret)

RUN bundle exec rake assets:precompile

EXPOSE 3000

CMD rails db:migrate &&\
    whenever --update-crontab &&\
    bundle exec puma -C config/puma.rb
