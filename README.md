rhinobird-api
============

[![Build Status](https://secure.travis-ci.org/rhinobird/rhinobird-api.png)](http://travis-ci.org/rhinobird/rhinobird-api) [![Dependency Status](https://gemnasium.com/rhinobird/webRTC.io.png)](https://gemnasium.com/rhinobird/webRTC.io) [![Code Climate](https://codeclimate.com/github/rhinobird/rhinobird-api.png)](https://codeclimate.com/github/rhinobird/rhinobird-api) [![Coverage Status](https://coveralls.io/repos/rhinobird/rhinobird-api/badge.png)](https://coveralls.io/r/rhinobird/rhinobird-api)

This repo should hold the Rails API for *streams* and *channels* (no *users* for the moment).
Take a look at http://docs.rhinobird.apiary.io/ for reference.

# Setup

## Requirements

### Redis

[Redis](http://redis.io/) is being used with [Sidekiq](sidekiq.org) for async tasks, you should install Redis database in order to run the application.

## Environment variables

### Host variables

* PUBLIC_HOST: The host for the frontend (ex. www.rhinobird.tv or localhost:9000)
* HOST_PROTOCOL: The host protocol server and backend (http or https)
* DEFAULT_SENDER: Default email sender for email notifications (ex. notify@rhinobird.tv)

### Licode related variables

* NUVE_SERVICE_ID: The Service ID given by Licode
* NUVE_SERVICE_KEY: The Service KEY given by Licode
* NUVE_SERVICE_HOST: The host where Licode is running (ex. http://streaming.rhinobird.tv/)

### Amazon environment variables

* AWS_BUCKET: bucket name to upload images
* AWS_ACCESS_KEY_ID: Key ID used for amazon services like S3 and SES
* AWS_SECRET_ACCESS_KEY: Access Key used for amazon services

### Social Network variables

* Facebook: FB_APP_ID, FB_APP_SECRET
* Twitter: TW_CONSUMER_KEY, TW_CONSUMER_SECRET
* Google: GOOGLE_KEY, GOOGLE_SECRET

### Other variables
* DEVISE_SECRET_KEY: The key generated with rake secret to use in production

# Run

You need to be sure that ENV variables are loaded before execute the following commands.

`bundle exec rails server`

`bundle exec sidekiq -q mailer -q default`
