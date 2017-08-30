require 'rails_helper'

RSpec.describe "Endpoints", type: :request do
  describe "POST /slack/:channel" do
    def rand_id
      rand(1..10000000)
    end

    context 'comment created' do
      let(:params) do
        JSON.parse(Rails.root.join('spec/data/comment_created_hook.jon').read)
      end
      let(:channel){'dev'}

      let(:notifier){instance_double(Slack::Notifier)}
      before do
        allow(Slack::Notifier).to receive(:new).and_return(notifier)
        allow(notifier).to receive(:post).and_return('')
      end

      it "notifies to slack" do
        is_expected.to eq 200

        expect(notifier).to have_received(:post).with(
          text: "Comment created in Project <https://3.basecamp.com/120348923894/projects/8310498/|RuboCop> Todo <https://3.basecamp.com/120348923894/buckets/8310498/todos/290347|Heredoc delimiter lowercase> by Masataka Pocke Kuwabara\n",
          attachments: [{
            text: "<https://3.basecamp.com/120348923894/buckets/8310498/todos/290347#__recording_5849357943759|Re: Heredoc delimiter lowercase>\nあっ、リリースされてない or sideciでは使ってないだけで存在したっぽい\nhttps://github.com/bbatsov/rubocop/blob/c243880cf6450542e11b99e50eb9093bd84c23ba/lib/rubocop/cop/naming/heredoc_delimiter_case.rb\n"
          }]
        )
      end
    end
  end
end
