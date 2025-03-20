FROM ruby:2.5.9-alpine

RUN gem install colorize -v 0.8.1

WORKDIR /app

COPY . /app

CMD ruby challenge_a.rb snappymob random_objects.txt && ruby challenge_b.rb random_objects.txt >> processed_objects.txt
