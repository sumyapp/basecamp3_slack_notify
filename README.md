# README
This is very simple Basecamp3 to Slack notify app.
If you using Basecamp3 and Slack, try this!

* Ruby version
  * 2.4.2
* System dependencies
  * All functions are implemented synchronously. Worker process is not required.
  * It works only with Heroku and MySQL add-on.
* Configuration
  * Please edit secrets.yml or your environment variables.
  * About Slack
    * ENV["SLACK_INCOMING_WEBHOOK_URL"]
      * Please add new incoming webhook to your slack channnel. And set the url to env
    * icon_emoji
      * Please add `:basecamp:` emoji to your slack team
  * About Basecamp3
    * This function is **Optional** function.
    * ENV["BASECAMP_INTEGRATION"]
      * If you want to use this func. please set `true`
    * Require register your app to https://launchpad.37signals.com/integrations
      * You can get these valiables.
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
