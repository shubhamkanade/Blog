FROM ruby:2.6.3-alpine3.8

RUN apk add --update ruby-dev build-base  \
  && apk add  libxslt-dev  nodejs \
  && apk add  tzdata \
  && gem install bundler -v 2.1.4 \
  && rm -rf /var/lib/apt/lists/* \ 
      /var/cache/apk/* \
      /usr/local/bundle/bundler/gems/*/.git \
      /usr/local/bundle/cache/

RUN mkdir /app

COPY Gemfile* /app/

RUN cd app && bundle install --without development

COPY . /app

WORKDIR /app

ARG RAILS_ENV=test

ENV RAILS_ENV=$RAILS_ENV

EXPOSE 3000

CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
