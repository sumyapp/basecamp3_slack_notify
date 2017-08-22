class EndpointController < ApplicationController
  skip_before_action :verify_authenticity_token
  require 'slacken'

  def slack
    notifier = Slack::Notifier.new Rails.application.secrets.slack["incoming_webhook_url"],
                channel: params[:channel], # Require specify channel via url
                username: Rails.application.secrets.slack["username"],
                icon_emoji: ":#{Rails.application.secrets.slack['icon_emoji']}:"

    mes = generate_messeage(params)
    notifier.ping mes

    render plain: mes
  end

  private
  # Todo created in Project <URL|PROJECT> Todolist <URL|LIST> by <URL|AUTHOR NAME>
  # <URL|TODO_TITLE>
  # CONTENT
  def generate_messeage(params)
    account_id, project_id = params[:recording][:parent][:app_url].split("/").values_at(3,5)
    mes = "#{params[:kind].underscore.humanize}"
    mes += " in #{params[:recording][:bucket][:type]} <https://3.basecamp.com/#{account_id}/projects/#{project_id}/|#{params[:recording][:bucket][:name]}>"
    mes += " #{params[:recording][:parent][:type]} <#{params[:recording][:parent][:app_url]}|#{params[:recording][:parent][:title]}>"
    mes += " by #{params[:creator][:name]}\n"
    mes += "<#{params[:recording][:app_url]}|#{params[:recording][:title]}>\n"
    mes += "#{Slacken.translate(params[:recording][:content])}\n" unless params[:recording][:title] == params[:recording][:content]
    mes
  end

end
