# README
This is very simple Basecamp3 to Slack notify app.
If you using Basecamp3 and Slack, try this!

[![Build Status](https://travis-ci.org/sideci/basecamp3_slack_notify.svg?branch=master)](https://travis-ci.org/sideci/basecamp3_slack_notify)
[![Coverage Status](https://coveralls.io/repos/github/sideci/basecamp3_slack_notify/badge.svg?branch=)](https://coveralls.io/github/sideci/basecamp3_slack_notify?branch=)

* Ruby version
  * 2.6.0
* System dependencies
  * All functions are implemented synchronously. Worker process is not required.
  * It works only with Heroku and MySQL add-on.
* Configuration
  * Please edit secrets.yml or your environment variables.
  * About Slack
    * ENV["SLACK_INCOMING_WEBHOOK_URL"]
      * Please add new incoming webhook to your slack channel. And set the url to env
    * icon_emoji
      * Please add `:basecamp:` emoji to your slack team
  * About Basecamp3
    * This function is **Optional** function.
    * ENV["BASECAMP_INTEGRATION"]
      * If you want to use this func. please set `true`
    * Require register your app to https://launchpad.37signals.com/integrations
      * You can get these variables.
      * ENV["BASECAMP_CLIENT_SECRET"]
      * ENV["BASECAMP_AUTH_REDIRECT_URI"]
    * You can know account id at this url `https://3.basecamp.com/$ACCOUNT_ID/projects`
      * ENV["BASECAMP_ACCOUNT_ID"] %>
* Database creation
  * `rake db:create`
* Database initialization
  * `rake db:migrate`
* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)
  * puma(app server)
  * mysql
* Deployment instructions
  * Please feel free to send me a pull request.
  * Now this application is really simple implementation.
