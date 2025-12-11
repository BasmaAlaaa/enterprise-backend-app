# Use an official Ruby runtime as a parent image
FROM ruby:3.0.2

# Set the working directory in the container
WORKDIR /myapp
# Copy Gemfile and Gemfile.lock to the container
COPY Gemfile* ./

# Install any needed packages specified in the Gemfile
RUN bundle install

COPY . .

# Make the entrypoint script executable
RUN chmod +x entrypoint.sh


# Expose port 3000 to the outside world
EXPOSE 3000

# Use the entrypoint script
# ENTRYPOINT ["./entrypoint.sh"]

# Start the main process
CMD ["rails", "server", "-b", "0.0.0.0"]
