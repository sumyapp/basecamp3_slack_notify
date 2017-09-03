class AccessToken < ApplicationRecord

  # Refresh latest auth token
  def refresh_access_token
    require 'uri'
    require 'net/http'
    require 'net/https'

    client_id = Rails.application.secrets.basecamp[:client_id]
    client_secret = Rails.application.secrets.basecamp[:client_secret]
    redirect_uri = Rails.application.secrets.basecamp[:redirect_uri]
    token_refresh_url = "https://launchpad.37signals.com/authorization/token"

    uri = URI.parse(token_refresh_url)
    https = Net::HTTP.new(uri.host,uri.port)
    https.use_ssl = true
    req = Net::HTTP::Post.new(uri.path)
    req.set_form_data('type' => 'refresh',
                      'refresh_token' => refresh_token,
                      'client_id' => client_id,
                      'redirect_uri' => redirect_uri,
                      'client_secret' => client_secret)
    res = https.request(req)
    auth_json = JSON.parse(res.body)

    if auth_json["access_token"] != nil && auth_json["expires_in"] != nil
      self.access_token = auth_json["access_token"]
      self.expires_at = Time.now + auth_json["expires_in"]
      self.save
    end
  end

end
