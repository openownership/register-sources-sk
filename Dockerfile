FROM ruby:3.1.2-bullseye

WORKDIR /app

COPY Gemfile Gemfile.lock register_sources_sk.gemspec /app/
COPY lib/register_sources_sk/version.rb /app/lib/register_sources_sk/

# Download public key for github.com
RUN mkdir -p -m 0700 ~/.ssh && ssh-keyscan github.com >> ~/.ssh/known_hosts

RUN --mount=type=ssh bundle install

COPY . /app/

CMD ["bundle", "exec", "rspec"]
