class EndpointController < ApplicationController
  skip_before_action :verify_authenticity_token

  def slack
    notifier = Slack::Notifier.new(
      Rails.application.secrets.slack[:incoming_webhook_url],
      channel: params[:channel], # Require specify channel via url
      username: Rails.application.secrets.slack[:username],
      icon_emoji: ":#{Rails.application.secrets.slack[:icon_emoji]}:"
    )

    account_id, project_id = params[:recording][:parent][:app_url].split("/").values_at(3,5)
    result = notifier.post text: generate_text(params, account_id, project_id),
                    attachments: generate_attachments(params, account_id, project_id)

    render plain: result
  end

  private
  # Todo created in Project <URL|PROJECT> Todolist <URL|LIST> by <URL|AUTHOR NAME>
  # <URL|TODO_TITLE>
  # CONTENT
  def generate_text(params, account_id, project_id)
    text = "#{params[:kind].underscore.humanize}"
    text += " in #{params[:recording][:bucket][:type]} <https://3.basecamp.com/#{account_id}/projects/#{project_id}/|#{params[:recording][:bucket][:name]}>"
    text += " #{params[:recording][:parent][:type]} <#{params[:recording][:parent][:app_url]}|#{params[:recording][:parent][:title]}>"
    text += " by #{params[:creator][:name]}\n"
    text
  end

  def generate_attachments(params, account_id, project_id)
    text = "<#{params[:recording][:app_url]}|#{params[:recording][:title]}>\n"
    if params[:recording][:title] != params[:recording][:content]
      p Rails.application.secrets.basecamp
      if Rails.application.secrets.basecamp[:integration] == true
        text += "#{Slacken.translate(replace_attachments(params[:recording][:content], account_id))}\n"
      else
        text += "#{Slacken.translate(params[:recording][:content])}\n"
      end
    end
    attachments = [{
      text: text
    }]
    attachments
  end

  # [Experimental/Optional feature] Require basecamp integration.
  # Translate basecamp attachments to plain texts
  def replace_attachments(recording_content, account_id)
    replaced_content = recording_content
    html_doc = Nokogiri::HTML(replaced_content)
    bc_attachments = html_doc.css "bc-attachment"
    bc_attachments.each do |attachment|
      # Find mention, if found, replace content
      if attachment["content-type"] == 'application/vnd.basecamp.mention'
        sgid = attachment["sgid"] # Person's ID
        person_name = sgid_to_person_name(sgid, account_id)
        attachment.name = "code" # Select HTML Inline element.
        attachment.content = person_name
      end
    end
    replaced_content = html_doc.to_html

    replaced_content
  end

  # Return person name via basecamp sgid
  # Call Person API or Use Cache the response
  def sgid_to_person_name(sgid, account_id)
    # TODO: Load hash from cache
    people_hash = Rails.cache.fetch('basecamp_sgid_name_hash')
    people_hash = {} if people_hash == nil

    # If can't find sgid in cache
    if people_hash[sgid] == nil
      # JSON to hash. And, cache the hash
      people_json = get_people_json(account_id)
      # Collect people name and sgid
      people_json.each do |person|
        people_hash[person["attachable_sgid"]] = person["name"]
      end
      # TODO: Save hash to cache
      Rails.cache.write 'basecamp_sgid_name_hash', people_hash
    end

    people_hash[sgid]
  end

  # Get a list of all pingable people
  def get_people_json(account_id)
    require 'open-uri'
    client_id = Rails.application.secrets.basecamp[:client_id]
    client_secret = Rails.application.secrets.basecamp[:client_secret]
    access_token = Rails.application.secrets.basecamp[:admin_access_token]

    # https://github.com/basecamp/bc3-api/blob/master/sections/people.md#get-pingable-people
    res = open("https://3.basecampapi.com/#{account_id}/circles/people.json",
                "Authorization" => "Bearer #{access_token}")
    people_json = ActiveSupport::JSON.decode res.read

    people_json
  end

end
