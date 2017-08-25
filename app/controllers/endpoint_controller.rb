class EndpointController < ApplicationController
  skip_before_action :verify_authenticity_token

  def slack
    notifier = Slack::Notifier.new(
      Rails.application.secrets.slack[:incoming_webhook_url],
      channel: params[:channel], # Require specify channel via url
      username: Rails.application.secrets.slack[:username],
      icon_emoji: ":#{Rails.application.secrets.slack[:icon_emoji]}:"
    )

    result = notifier.post text: generate_text(params), attachments: generate_attachments(params)

    render plain: result
  end

  private
  # Todo created in Project <URL|PROJECT> Todolist <URL|LIST> by <URL|AUTHOR NAME>
  # <URL|TODO_TITLE>
  # CONTENT
  def generate_text(params)
    account_id, project_id = params[:recording][:parent][:app_url].split("/").values_at(3,5)
    text = "#{params[:kind].underscore.humanize}"
    text += " in #{params[:recording][:bucket][:type]} <https://3.basecamp.com/#{account_id}/projects/#{project_id}/|#{params[:recording][:bucket][:name]}>"
    text += " #{params[:recording][:parent][:type]} <#{params[:recording][:parent][:app_url]}|#{params[:recording][:parent][:title]}>"
    text += " by #{params[:creator][:name]}\n"
    text
  end

  def generate_attachments(params)
    text = "<#{params[:recording][:app_url]}|#{params[:recording][:title]}>\n"
    text += "#{Slacken.translate(params[:recording][:content])}\n" unless params[:recording][:title] == params[:recording][:content]
    attachments = [{
      text: text
    }]
    attachments
  end

end
