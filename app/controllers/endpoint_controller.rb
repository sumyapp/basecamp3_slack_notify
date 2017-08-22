class EndpointController < ApplicationController
  skip_before_action :verify_authenticity_token
  require 'slacken'

  def slack
    notifier = Slack::Notifier.new Rails.application.secrets.slack["incoming_webhook_url"],
                channel: params[:channel], # Require specify channel via url
                username: Rails.application.secrets.slack["username"],
                icon_emoji: ":#{Rails.application.secrets.slack['icon_emoji']}:"

    mes = generate_messeage_with_links(params)
    notifier.ping mes

    render plain: mes
  end

  private
  # Todo created in Project <URL|PROJECT> Todolist <URL|LIST> by <URL|AUTHOR NAME>
  # <URL|TODO_TITLE>
  # CONTENT
  def generate_messeage_with_links(params)
    account_id, project_id = params[:recording][:parent][:app_url].split("/").values_at(3,5)
    mes = "#{params[:kind].underscore.humanize}"
    mes += " in #{params[:recording][:bucket][:type]} <https://3.basecamp.com/#{account_id}/projects/#{project_id}/|#{params[:recording][:bucket][:name]}>"
    mes += " #{params[:recording][:parent][:type]} <#{params[:recording][:parent][:app_url]}|#{params[:recording][:parent][:title]}>"
    mes += " by #{params[:creator][:name]}\n"
    mes += "<#{params[:recording][:app_url]}|#{params[:recording][:title]}>\n"
    mes += "#{Slacken.translate(params[:recording][:content])}\n" unless params[:recording][:title] == params[:recording][:content]
    mes
  end

  # NOTE: Unused method. If you like more verbose text, this is more better than with_links
  # https://3.basecamp.com/0000000/buckets/0000000/todos/000000000
  # Project `PROJECT` Todolist `LIST`
  # Title: TODO_TITLE
  # Content: CONTENT (optional)
  # is todo_completed by AUTHOR NAME
  def generate_messeage(params)
    mes = "#{params[:recording][:app_url]}\n"
    mes += "#{params[:recording][:bucket][:type]} `#{params[:recording][:bucket][:name]}` "
    mes += "#{params[:recording][:parent][:type]} `#{params[:recording][:parent][:title]}`\n"
    mes += "Title: #{params[:recording][:title]}\n"
    mes += "Content: #{Slacken.translate(params[:recording][:content])}\n" unless params[:recording][:title] == params[:recording][:content]
    mes += "is #{params[:kind]} by #{params[:creator][:name]}\n"
  end

end
