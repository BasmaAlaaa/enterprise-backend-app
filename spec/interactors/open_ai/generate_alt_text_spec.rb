require 'rails_helper'

RSpec.describe OpenAi::GenerateAltText do
  describe '.call' do
    let(:client) { instance_double(OpenAI::Client) }
    let(:subscription_plan) { build(:subscription_plan) }
    let(:account_owner) { build(:account_owner) }
    let(:integration) { create(:integration , account_owner: account_owner) }
    let(:subscription) { create(:subscription, account_owner: account_owner, subscription_plan: subscription_plan) }
    let(:statistics) { create(:statistics, integration: integration) }
    let(:valid_params) do
      {
        params: { image_url: 'https://example.com/image.jpg' },
        integration: integration

      }
    end
    let(:client_response) do
      {
        'choices' => [{
          'message' => {
            'content' => 'A scenic view of the mountains under a clear blue sky'
          }
        }],
        'usage' => {
          'total_tokens' => 20
        }
      }
    end

    before do
      allow(OpenAI::Client).to receive(:new).and_return(client)
      allow(client).to receive(:chat).and_return(client_response)
      subscription
      integration
      statistics
    end

    context 'when valid parameters are provided' do
      it 'successfully generates alt text and updates statistics' do
        result = described_class.call(valid_params)
        expect(result).to be_a_success
        expect(result.response).to eq(client_response)
        expect(result.content).to eq({alt_text: 'A scenic view of the mountains under a clear blue sky'})
        statistics.reload
        subscription.reload
        expect(statistics.image_alt_text).to eq(1) and expect(statistics.total_words).to eq(20)
        
      end
    end
  end
end
