class SetupController < ApplicationController

  # Setup: 1. Access /setup/index
  # Redirect to basecamp authentication url
  # https://github.com/basecamp/api/blob/master/sections/authentication.md#oauth-2-from-scratch
  def index
    client_id = Rails.application.secrets.basecamp[:client_id]
    redirect_uri = Rails.application.secrets.basecamp[:redirect_uri]
    auth_uri = "https://launchpad.37signals.com/authorization/new?type=web_server&client_id=#{client_id}&redirect_uri=#{redirect_uri}"

    redirect_to auth_uri
  end

  # Setup: 2. Callback /setup/callback
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
    auth_json = JSON.parse(res.body)

    # Store token to database. latest registerd token will use
    AccessToken.create access_token: auth_json["access_token"],
                      refresh_token: auth_json["refresh_token"],
                         expires_at: (Time.now.utc + auth_json["expires_in"])

    render plain: auth_json
  end

end
