![Twilio Logo](./twilio_logo_red.png)
# Twilio Account Security Quickstart - Two-Factor Authentication and Phone Verification

A simple Ruby on Rails implementation of a website that uses Twilio Account
Security services to protect all assets within a folder. Additionally, it
shows a Phone Verification implementation.

It uses four channels for delivery, SMS, Voice, Soft Tokens, and Push
Notifications. You should have the [Authy App](https://authy.com/download/)
installed to try Soft Token and Push Notification support.

This app uses [SQLite](https://www.sqlite.org/) as a data store. You will
have to install SQLite as well and make sure it is running.

#### Two-Factor Authentication Demo
- URL path "/protected" is protected with both user session and Twilio Two-Factor Authentication
- One Time Passwords (SMS and Voice)
- SoftTokens
- Push Notifications (via polling)

#### Phone Verification
- Phone Verification
- SMS or Voice Call

### Setup
1. Clone this repo
   ```sh
   git clone https://github.com/TwilioDevEd/account-security-quickstart-rails.git
   cd account-security-quickstart-rails
   ```

1. Run `bundle install`

1. Register for a [Twilio Account](https://www.twilio.com/).

1. Setup an Account Security app via the [Twilio Console](https://twilio.com/console).

1. Create your `application.yml` file from the existing example in `config/application.example.yml`
   ```sh
   cp config/application.example.yml config/application.yml
   ```

1. Generate an Application **API KEY** from the Dashboard and paste it in `.env`

1. Check and make sure SQLite is up and running

1. Run `bin/rails db:migrate` to create the tables

1. Run `bin/rails server` to start the server

### License
- MIT
