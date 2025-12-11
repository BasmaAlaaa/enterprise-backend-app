#!/bin/bash
set -e

# Remove a potentially pre-existing server.pid for Rails.
rm -f /usr/src/app/tmp/pids/server.pid

# Run database migrations if necessary
bundle exec rails db:create 
bundle exec rails db:migrate 

# Then exec the container's main process (what's set as CMD in the Dockerfile).
exec "$@"
