rhinobird-api
============

[![Build Status](https://secure.travis-ci.org/rhinobird/rhinobird-api.png)](http://travis-ci.org/rhinobird/rhinobird-api) [![Dependency Status](https://gemnasium.com/rhinobird/webRTC.io.png)](https://gemnasium.com/rhinobird/webRTC.io) [![Code Climate](https://codeclimate.com/github/rhinobird/rhinobird-api.png)](https://codeclimate.com/github/rhinobird/rhinobird-api) [![Coverage Status](https://coveralls.io/repos/rhinobird/rhinobird-api/badge.png)](https://coveralls.io/r/rhinobird/rhinobird-api)

This repo should hold the Rails API for *streams* and *channels* (no *users* for the moment).
Take a look at http://docs.rhinobird.apiary.io/ for reference.

# Setup

## Environment variables

### Host variables

* DEFAULT_HOST: The host for the server (ex. http://beta.rhinobird.tv/ or localhost:3000)
* PUBLIC_HOST: The host for the frontend (ex. www.rhinobird.tv or localhost:9000)
* HOST_PROTOCOL: The host protocol server and backend (http or https)
* DEFAULT_SENDER: Default email sender for email notifications (ex. notify@rhinobird.tv)
* API_SCOPE_NAME: The scope for the api route (`v1` for api.rhinobird.tv/v1)

### Licode related variables

* NUVE_SERVICE_ID: The Service ID given by Licode
* NUVE_SERVICE_KEY: The Service KEY given by Licode
* NUVE_SERVICE_HOST: The host where Licode is running (ex. http://streaming.rhinobird.tv/)

### Amazon environment variables

* AWS_KEY_ID: Key ID used for amazon services like S3 and SES
* AWS_ACCESS_KEY: Access Key used for amazon services

### Social Network variables

* Facebook: FB_APP_ID, FB_APP_SECRET
* Twitter: TW_CONSUMER_KEY, TW_CONSUMER_SECRET
* Google: GOOGLE_KEY, GOOGLE_SECRET

### Other variables
* DEVISE_SECRET_KEY: The key generated with rake secret to use in production
