FROM ruby:2.7.6-alpine

RUN gem install colorize

WORKDIR /app

COPY . /app

CMD ruby challenge_a.rb snappymob random_objects.txt && ruby challenge_b.rb random_objects.txt >> processed_objects.txt
