FROM ruby:2.6.5-alpine3.11

ENV LANG=C.UTF-8
ENV TZ=Asia/Tokyo
ENV APP_ROOT="/app"

WORKDIR ${APP_ROOT}
COPY Gemfile ${APP_ROOT}
COPY Gemfile.lock ${APP_ROOT}

RUN set -x \
  apk update && \
  apk add --no-cache --virtual .build-deps \
  build-base \
  curl-dev \
  linux-headers && \
  apk add --no-cache \
  bash \
  git \
  mysql-dev \
  nodejs \
  tzdata \
  yarn && \
  gem install bundler && \
  bundle install && \
  apk del .build-deps

RUN mkdir -p tmp/sockets tmp/pids
COPY . ${APP_ROOT}

# Expose volumes to frontend
VOLUME /app/public
VOLUME /app/tmp

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

# Start the main process.
CMD ["bundle", "exec", "pumactl", "start"]