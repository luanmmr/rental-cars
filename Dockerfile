FROM ruby:2.6.3

RUN apt update -yqq && apt install -yqq --no-install-recommends \
  nodejs

COPY Gemfile* /usr/src/app/
WORKDIR /usr/src/app

RUN bundle install

COPY . /user/src/app

RUN gem install mini_racer -v '0.6.3' --source 'https://rubygems.org/'

CMD [ "bin/setup" ]