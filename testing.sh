#!/bin/bash
# docker-compose down
# docker-compose rm $(docker ps -q -f status=exited)
# echo "Running tests in a fully containerized environment..."
# docker-compose up -d blog user post
# sleep 15
# docker-compose run blog bundle exec rails db:create
# docker-compose run blog bundle exec rails db:migrate
# echo "Databse created..."
# docker-compose run blog bundle exec rails test
# docker-compose down