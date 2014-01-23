peepoltv-api
============

[![Build Status](https://secure.travis-ci.org/peepoltv/peepoltv-api.png)](http://travis-ci.org/peepoltv/peepoltv-api) [![Dependency Status](https://gemnasium.com/peepoltv/webRTC.io.png)](https://gemnasium.com/peepoltv/webRTC.io) [![Code Climate](https://codeclimate.com/github/peepoltv/peepoltv-api.png)](https://codeclimate.com/github/peepoltv/peepoltv-api) [![Coverage Status](https://coveralls.io/repos/peepoltv/peepoltv-api/badge.png)](https://coveralls.io/r/peepoltv/peepoltv-api)

This repo should hold the Rails API for *streams* and *channels* (no *users* for the moment).
Take a look at http://docs.peepoltv.apiary.io/ for reference.

# Setup

## Environment variables

### Host variables

* DEFAULT_HOST: The host for the server (ex. http://beta.peepol.tv/ or localhost:3000)
* PUBLIC_HOST: The host for the frontend (ex. www.peepol.tv or localhost:9000)
* HOST_PROTOCOL: The host protocol server and backend (http or https)
* DEFAULT_SENDER: Default email sender for email notifications (ex. notify@peepol.tv)

### Licode related variables

* NUVE_SERVICE_ID: The Service ID given by Licode
* NUVE_SERVICE_KEY: The Service KEY given by Licode
* NUVE_SERVICE_HOST: The host where Licode is running (ex. http://streaming.peepol.tv/)

### Amazon environment variables

* AWS_KEY_ID: Key ID used for amazon services like S3 and SES
* AWS_ACCESS_KEY: Access Key used for amazon services

### Social Network variables

* Facebook: FB_APP_ID, FB_APP_SECRET
* Twitter: TW_CONSUMER_KEY, TW_CONSUMER_SECRET
* Google: GOOGLE_KEY, GOOGLE_SECRET
