require 'rails_helper'

RSpec.describe OpenAi::Products::GenerateBulkTitles, type: :interactor do
  describe '#call' do
    let(:open_ai_client) { instance_double(OpenAI::Client) }
    let(:subscription_plan) { build(:subscription_plan) }
    let(:account_owner) { build(:account_owner) }
    let(:integration) { build(:integration , account_owner: account_owner) }
    let(:subscription) { create(:subscription, account_owner: account_owner, subscription_plan: subscription_plan) }
    let(:statistics) { create(:statistics, integration: integration) }
    let(:params) {
      {
        number_of_products: 4,
        products: "[{id: 1 , title: 'green jacket'}, {id: 2, title: 'floral white top'}, {id: 3, title: 'black jeans'}, {id: 4, title: 'red socks'}]",
        language: "English"
      }
    }
    let(:mock_response){
      {
        'choices' => [
          { 'message' => { 'content' => '{"id": 1, "title": "Green Jacket"}' } },
          { 'message' => { 'content' => '{"id": 2, "title": "Floral White Top"}' } },
          { 'message' => { 'content' => '{"id": 3, "title": "Black Jeans"}' } },
          { 'message' => { 'content' => '{"id": 4, "title": "Red Socks"}' } }
        ],
        'usage' => { 'total_tokens' => 4 }
      }
    }
    let(:interactor) { described_class.new(params: params, integration: integration) }

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
        expect(statistics.total_words).to eq(4) and expect(statistics.product_title).to eq(4) and expect(statistics.product_description).to eq(0) and expect(statistics.product_seo).to eq(0)
        expect(subscription.remaining_generations).to eq(996)
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
