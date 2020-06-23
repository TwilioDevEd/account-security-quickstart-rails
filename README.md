![Twilio Logo](./twilio_logo_red.png)
# Twilio Account Security Quickstart - Twilio Authy and Twilio Verify

![](https://github.com/TwilioDevEd/account-security-quickstart-rails/workflows/Ruby/badge.svg)

> This template is part of Twilio CodeExchange. If you encounter any issues with this code, please open an issue at [github.com/twilio-labs/code-exchange/issues](https://github.com/twilio-labs/code-exchange/issues).

## About

A simple Ruby on Rails implementation of a website that uses Twilio Authy Two-factor Authentication to protect all assets within a folder. Additionally, it shows a Twilio Verify Phone Verification implementation.

It uses four channels for delivery, SMS, Voice, Soft Tokens, and Push
Notifications. You should have the [Authy App](https://authy.com/download/)
installed to try Soft Token and Push Notification support.

Learn more about Account Security and when to use the Authy API vs the Verify API in the [Account Security documentation](https://www.twilio.com/docs/verify/authy-vs-verify).

Implementations in other languages:

| .NET | Java | Python | PHP | Node |
| :--- | :--- | :----- | :-- | :--- |
| TBD | [Done](https://github.com/TwilioDevEd/account-security-quickstart-spring)  | [Done](https://github.com/TwilioDevEd/account-security-quickstart-django)    | [Done](https://github.com/TwilioDevEd/account-security-quickstart-php) | [Done](https://github.com/TwilioDevEd/account-security-quickstart-node)  |

## Features

#### Two-Factor Authentication Demo
- URL path "/protected" is protected with both user session and Twilio Authy Two-Factor Authentication
- One Time Passwords (SMS and Voice)
- SoftTokens
- Push Notifications (via polling)

#### Phone Verification
- Phone Verification
- SMS or Voice Call

## Set up

### Requirements

- [Ruby](https://www.ruby-lang.org/) **2.6.x** version
- [Sqlite3](https://www.sqlite.org/)

### Twilio Account Settings

This application should give you a ready-made starting point for writing your own application.
Before we begin, we need to collect all the config values we need to run the application:

| Config Value | Description |
| :----------  | :---------- |
| ACCOUNT_SECURITY_API_KEY  | Create a new Authy application in the [console](https://www.twilio.com/console/authy/). After you give it a name you can view the generated Account Security production API key. This is the string you will later need to set up in your environmental variables.|

### Local Development
1. Clone this repo
   ```sh
   git clone https://github.com/TwilioDevEd/account-security-quickstart-rails.git
   cd account-security-quickstart-rails
   ```

1. Install dependencies.

   ```bash
    make install
   ```

1. Set your environment variables.

   ```bash
    cp .env.example .env
   ```

   See [Twilio Account Settings](#twilio-account-settings) to locate the necessary environment variables.

1. Create the database.

   ```bash
    make database
   ```

1. Start the server.

   ```bash
    make serve
   ```

1. Navigate to [http://localhost:3000](http://localhost:3000)

That's it!

### Docker

If you have [Docker](https://www.docker.com/) already installed on your machine, you can use our `docker-compose.yml` to setup your project.

1. Make sure you have the project cloned.
2. Setup the `.env` file as outlined in the [Local Development](#local-development) steps.
3. Run `docker-compose up`.


### Tests

You can run the tests locally by typing:

```bash
bundle exec rspec
```

### Cloud deployment

Additionally to trying out this application locally, you can deploy it to a variety of host services. Here is a small selection of them.

Please be aware that some of these might charge you for the usage or might make the source code for this application visible to the public. When in doubt research the respective hosting service first.

| Service                           |                                                                                                                                                                                                                           |
| :-------------------------------- | :------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| [Heroku](https://www.heroku.com/) | [![Deploy](https://www.herokucdn.com/deploy/button.svg)](https://heroku.com/deploy)                                                                                                                                       |

## Resources

- The CodeExchange repository can be found [here](https://github.com/twilio-labs/code-exchange/).

## Contributing

This template is open source and welcomes contributions. All contributions are subject to our [Code of Conduct](https://github.com/twilio-labs/.github/blob/master/CODE_OF_CONDUCT.md).

## License

[MIT](http://www.opensource.org/licenses/mit-license.html)

## Disclaimer

No warranty expressed or implied. Software is as is.

[twilio]: https://www.twilio.com
