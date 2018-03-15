FROM ruby:2.3
MAINTAINER KiryanenkoAV@gmail.com

# Install apt based dependencies required to run Rails as well as RubyGems.
# As the Ruby image itself is based on a Debian image, we use apt-get to install those.
RUN apt-get update && apt-get install -y \
  build-essential \
  nodejs


# Установка postgresql
ENV PGVER 9.5
RUN apt-get install -y postgresql-$PGVER

# Run the rest of the commands as the ``postgres`` user created by the ``postgres-$PGVER`` package when it was ``apt-get installed``
USER postgres

# Create a PostgreSQL role named ``docker`` with ``docker`` as the password and
# then create a database `docker` owned by the ``docker`` role.
RUN /etc/init.d/postgresql start &&\
    psql --command "CREATE USER smartparking WITH SUPERUSER PASSWORD '123456';" &&\
    createdb -E utf8 -T template0 -O smartparking smartparking &&\
    /etc/init.d/postgresql stop

# Expose the PostgreSQL port
EXPOSE 5432

# Add VOLUMEs to allow backup of config, logs and databases
VOLUME  ["/etc/postgresql", "/var/log/postgresql", "/var/lib/postgresql"]


# Back to the root user
USER root

# Configure the main working directory.
# This is the base directory used in any further RUN, COPY, and ENTRYPOINT commands.
ENV APP /app
ADD ./ $APP
WORKDIR $APP

# Install the RubyGems.
# This is a separate step so the dependencies will be cached unless changes to one of those two files are made.
RUN gem install bundler && bundle install --jobs 20 --retry 5

# Expose port 3000 to the Docker host, so we can access it
# from the outside.
EXPOSE 3000

# The main command to run when the container starts.
# Also tell the Rails dev server to bind to all interfaces by default.
CMD service postgresql start && bundle exec rails server -b 0.0.0.0
