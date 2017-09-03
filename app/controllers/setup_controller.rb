class SetupController < ApplicationController

  # Setup: 1. Access /setup/index
  # Redirect to basecamp authentication url
  # https://github.com/basecamp/api/blob/master/sections/authentication.md#oauth-2-from-scratch
  def index
    client_id = Rails.application.secrets.basecamp[:client_id]
    client_secret = Rails.application.secrets.basecamp[:client_secret]
    redirect_uri = Rails.application.secrets.basecamp[:redirect_uri]
    auth_uri = "https://launchpad.37signals.com/authorization/new?type=web_server&client_id=#{client_id}&redirect_uri=#{redirect_uri}"

    redirect_to auth_uri
  end

  # Setup: 2. Callback /setup/callback
  # Save view token
  # Please note the token. After that, setup the token to ENV
  def callback
    require 'uri'
    require 'net/http'
    require 'net/https'

    client_id = Rails.application.secrets.basecamp[:client_id]
    client_secret = Rails.application.secrets.basecamp[:client_secret]
    redirect_uri = Rails.application.secrets.basecamp[:redirect_uri]
    auth_uri_via_post = "https://launchpad.37signals.com/authorization/token"
    verification_code = params[:code]

    uri = URI.parse(auth_uri_via_post)
    https = Net::HTTP.new(uri.host,uri.port)
    https.use_ssl = true
    req = Net::HTTP::Post.new(uri.path)
    req.set_form_data('type' => 'web_server',
                      'client_id' => client_id,
                      'redirect_uri' => redirect_uri,
                      'client_secret' => client_secret,
                      'code' => verification_code)
    res = https.request(req)
    puts "Response #{res.code} #{res.message}: #{res.body}"
    auth_json = JSON.parse(res.body)

    # TODO: Token will expire 2 week. So need refresh token automaticaly
    # This is URL for token refresh
    # POST https://launchpad.37signals.com/authorization/token?type=refresh&refresh_token=your-current-refresh-token&client_id=your-client-id&redirect_uri=your-redirect-uri&client_secret=your-client-secret

    render plain: auth_json
  end

  # TODO: Refresh all auth tokens
  def refresh_tokens
  end

  # NOTE: I will implement these function
  # Function 1: Create webhook automaticaly
  # 0. Get all projects
  # https://github.com/basecamp/bc3-api/blob/master/sections/projects.md#projects
  # 1. Create a webhook
  # https://github.com/basecamp/bc3-api/blob/master/sections/webhooks.md#create-a-webhook
end
