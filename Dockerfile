FROM ruby:2.6

WORKDIR /usr/src/app

COPY Gemfile ./

RUN bundle install

COPY . .

# Install a Javascript environment in the container to avoid ExecJS::RuntimeUnavailable
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash - \
    && apt install -y nodejs

RUN rails db:migrate

EXPOSE 3000

CMD ["rails", "server", "--binding", "0.0.0.0"]
