require 'rails_helper'

RSpec.describe OpenAi::GenerateImage, type: :interactor do
  describe '#call' do
    let(:open_ai_client) { instance_double(OpenAI::Client, images: double) }
    let(:image_service) { double('ImageService') }
    let(:subscription_plan) { build(:subscription_plan) }
    let(:account_owner) { build(:account_owner) }
    let(:integration) { build(:integration , account_owner: account_owner) }
    let(:subscription) { create(:subscription, account_owner: account_owner, subscription_plan: subscription_plan) }
    let(:statistics) { create(:statistics, integration: integration) }
    let(:params) {
      {
        size: "1024x1024",
        format: "photograph",
        subject: "whale in space",
        perspective: "through a porthole",
        vibe: "futuristic",
        booster: "4k resolution",
        exclusion: "no planets",
        style: "surrealism"
      }
    }
    let(:interactor) { described_class.new(params: params, integration: integration) }
    let(:response) {
      {
        "data" => [
          {"url" => "http://example.com/generated_image.jpg"}
        ]
      }
    }

    before do
      allow(OpenAI::Client).to receive(:new).and_return(open_ai_client)
      allow(open_ai_client.images).to receive(:generate).and_return(response)  
      subscription
      integration
      statistics
    end

    
    context 'when the API call is successful' do
      it 'mocks api call and generates an image' do
        interactor.call
        expected_parts = [
          params[:format], params[:subject], params[:perspective],
          "style of #{params[:style]}", params[:vibe], params[:booster],
          "Exclude (#{params[:exclusion]})"
        ]
        expect(open_ai_client.images).to have_received(:generate) do |args|
          prompt = args.dig(:parameters, :prompt)
          expected_parts.all? { |part| prompt.include?(part) }
        end
        expect(interactor.context.content[:url]).to eq("http://example.com/generated_image.jpg")
      end

      it 'updates statistics and subscription correctly' do
        interactor.call
        statistics.reload
        subscription.reload
        expect(statistics.images).to eq(1)
        expect(subscription.remaining_images).to eq(0)
      end
    end

    context 'when the API call fails' do
      before do
        allow(open_ai_client.images).to receive(:generate).and_return("error" => { "message" => "Limit exceeded" })
      end

      it 'handles API errors by failing with the appropriate message' do
        expect { interactor.call }.to raise_error(Interactor::Failure)
        expect(interactor.context.errors).to include('Limit exceeded')
      end
    end
  end
end
