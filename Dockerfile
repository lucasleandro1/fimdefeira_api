# Stage 1: Build
FROM ruby:3.2.2 AS build

# Install dependencies
RUN apt-get update -qq && apt-get install -y \
  build-essential \
  sqlite3 \
  nodejs \
  && rm -rf /var/lib/apt/lists/*

# Set up the working directory
WORKDIR /app

# Install bundler
RUN gem install bundler

# Copy the Gemfile and Gemfile.lock
COPY Gemfile Gemfile.lock ./

# Install gems
RUN bundle install

# Copy the application code
COPY . .

# Precompile assets (not needed for API-only apps, but included here if you have any assets)
# RUN bundle exec rake assets:precompile

# Stage 2: Run
FROM ruby:3.2.2

# Install dependencies
RUN apt-get update -qq && apt-get install -y \
  sqlite3 \
  nodejs \
  && rm -rf /var/lib/apt/lists/*

# Set up the working directory
WORKDIR /app

# Copy the gems and application code from the build stage
COPY --from=build /usr/local/bundle /usr/local/bundle
COPY --from=build /app /app

# Expose the port that the Rails server will run on
EXPOSE 3000

# Start the Rails server by default
CMD ["rails", "server", "-b", "0.0.0.0"]