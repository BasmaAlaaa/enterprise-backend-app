require 'rails_helper'

RSpec.describe OpenAi::Products::GenerateTitle, type: :interactor do
  describe '#call' do
    let(:open_ai_client) { instance_double(OpenAI::Client) }
    let(:subscription_plan) { build(:subscription_plan) }
    let(:account_owner) { build(:account_owner) }
    let(:integration) { build(:integration , account_owner: account_owner) }
    let(:subscription) { create(:subscription, account_owner: account_owner, subscription_plan: subscription_plan) }
    let(:statistics) { create(:statistics, integration: integration) }
    let(:params) { {title: "green jacket", store: "from Rubix", language: "English"} }
    let(:mock_response){{
      'choices' => [
        { 'message' => { 'content' => JSON.generate({'title' => "green jacket"}) } }
      ],
      'usage' => { 'total_tokens' => 1}
    }}
    let(:interactor) { described_class.new(integration: integration, params: params) }

    before do
      allow(OpenAI::Client).to receive(:new).and_return(open_ai_client)
      subscription
      integration
      statistics
    end

    context 'succeeds' do
      it 'mocks api call correctly' do
        expect(open_ai_client).to receive(:chat).and_return(mock_response)
        interactor.call
      end

      it 'updates statistics and subscription correctly' do
        expect(open_ai_client).to receive(:chat).and_return(mock_response)
        interactor.call
        statistics.reload
        subscription.reload
        expect(statistics.total_words).to eq(1) and expect(statistics.product_title).to eq(1) and expect(statistics.product_description).to eq(0) and expect(statistics.product_seo).to eq(0)
        expect(subscription.remaining_generations).to eq(999)
      end
    end

    context 'fails' do
      it 'handles API errors by failing with the appropriate message' do
        api_error_response = {
          'error' => { 'message' => 'API limit exceeded' }
        }
        expect(open_ai_client).to receive(:chat).and_return(api_error_response)
        expect { interactor.call }.to raise_error(Interactor::Failure)
        expect(interactor.context.errors).to include('API limit exceeded')
      end

      it 'handles content errors' do
        content_error_response = {
          'choices' => [
            { 'message' => { 'content' => '{"error": "Invalid input data"}' } }
          ],
          'usage' => { 'total_tokens' => 4 }
        }
        expect(open_ai_client).to receive(:chat).and_return(content_error_response)
        expect { interactor.call }.to raise_error(Interactor::Failure)
        expect(interactor.context.errors).to include('Invalid input data')
      end
    end
  end
end
