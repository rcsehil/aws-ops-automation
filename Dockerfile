FROM ruby:2.5.5-alpine

COPY ./ /app

WORKDIR /app

RUN gem install bundler
RUN bundle install

WORKDIR /workspace

CMD ["/bin/sh"]
