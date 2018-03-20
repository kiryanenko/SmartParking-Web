FROM ubuntu:16.04
MAINTAINER KiryanenkoAV@gmail.com

# Install apt based dependencies required to run Rails as well as RubyGems.
# As the Ruby image itself is based on a Debian image, we use apt-get to install those.
RUN apt-get update && apt-get install -y \
  libffi-dev \
  libgmp-dev \
  libpq-dev \
  ruby \
  ruby-dev \
  nodejs \
  git \
  build-essential \
  zlib1g-dev \
  npm \
  nodejs
RUN ln -s /usr/bin/nodejs /usr/bin/node
RUN gem install bundler
RUN npm install yarn -g


# Установка postgresql
ENV PGVER 9.5
RUN apt-get install -y postgresql-$PGVER postgresql-contrib postgis

# Run the rest of the commands as the ``postgres`` user created by the ``postgres-$PGVER`` package when it was ``apt-get installed``
USER postgres

# Create a PostgreSQL role named ``docker`` with ``docker`` as the password and
# then create a database `docker` owned by the ``docker`` role.
RUN /etc/init.d/postgresql start &&\
    psql --command "CREATE USER smartparking WITH SUPERUSER PASSWORD '123456';" &&\
    createdb -E utf8 -T template0 -O smartparking smartparking &&\
    createdb -E utf8 -T template0 -O smartparking smartparking_test &&\
    /etc/init.d/postgresql stop

# Expose the PostgreSQL port
EXPOSE 5432

# Add VOLUMEs to allow backup of config, logs and databases
VOLUME ["/etc/postgresql", "/var/log/postgresql", "/var/lib/postgresql"]

# FIX Peer authentication failed for user
ADD pg_hba.conf /etc/postgresql/$PGVER/main


# Back to the root user
USER root


# Установка nginx
RUN apt-get install -y nginx

ADD smartparking_nginx.conf /etc/nginx/sites-available
RUN ln -s /etc/nginx/sites-available/smartparking_nginx.conf /etc/nginx/sites-enabled/
RUN nginx -t

# Expose port 80 to the Docker host, so we can access it
# from the outside.
EXPOSE 80


# Configure the main working directory.
# This is the base directory used in any further RUN, COPY, and ENTRYPOINT commands.
ENV APP /app
WORKDIR $APP

# Install the RubyGems.
# This is a separate step so the dependencies will be cached unless changes to one of those two files are made.
ADD ./Gemfile $APP
RUN bundle install --jobs 20

ENV SECRET_KEY_BASE d30ddf547b1d600cb40d659380ddb17c70f55317886b88e5859a0c02363296ea956c95cc3b44f1b899354de3b6e0aa632981721780a9371d00300828d57cb971
ENV DATABASE_URL postgis://smartparking:123456@localhost/smartparking
ADD ./ $APP

RUN RAILS_ENV=production rails assets:precompile

# Add VOLUMEs to allow logs
VOLUME $APP/log


# The main command to run when the container starts.
# Also tell the Rails dev server to bind to all interfaces by default.
CMD service nginx start &&\
    service postgresql start &&\
    RAILS_ENV=production rake db:gis:setup &&\
    RAILS_ENV=production rails db:migrate &&\
    bundle exec puma -b unix:///var/run/smartparking.sock -e production
