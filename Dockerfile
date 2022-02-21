FROM ruby:3.0

# Allow apt to work with https-based sources      
RUN apt-get update -yqq && apt-get install -yqq --no-install-recommends \
  apt-transport-https \
  && rm -rf /var/lib/apt/lists/* /var/cache/apt

# Ensure we install an up-to-date version of Node
# See https://github.com/yarnpkg/yarn/issues/2888
RUN curl -sL https://deb.nodesource.com/setup_16.x | bash -

# Ensure latest packages for Yarn
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | \
  tee /etc/apt/sources.list.d/yarn.list

# Install packages
RUN apt-get update -yqq && apt-get install -yqq --no-install-recommends \
  nodejs \
  yarn \
  && yarn --version

WORKDIR /app
COPY ./Gemfile* /app/
RUN bundle config --local without "staging production omit" && bundle install --jobs $(nproc) --retry 5
COPY ./package.json /app/
COPY ./yarn.lock /app/
RUN yarn install
COPY . /app

CMD ["bin/rails", "s", "-b", "0.0.0.0"]
