require 'rails_helper'

RSpec.describe Api::OpenAiController, type: :controller do
  let(:account_owner) { create(:account_owner) }
  let(:integration) { create(:integration) }
  let(:status) { :processing }
  let(:generation) { create(:generation, integration: integration, generation_type: 'article', status: status) }

  before do
    sign_in(account_owner)
    generation
  end

  context "when generation is processing" do
    it "returns an error" do
      post :reset_generation, params: { integration_id: integration.id, generation_type: 'article' }
      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.body).to include("There is a generation already processing")
      end
  end

  context "when generation is not processing" do
    let(:status) { :done }

    it "hides the generation" do
      post :reset_generation, params: { integration_id: integration.id, generation_type: 'article' }
      expect(response).to be_successful 
      expect(Generation.find(generation.id).status).to eq('hidden') 
    end
  end

  context "returning the last generation" do
    it "returns the last generation" do
      get :index, params: { integration_id: integration.id, generation_type: 'article' }
          expect(response).to have_http_status(:success)
          json_response = JSON.parse(response.body)
          expect(json_response["id"]).to eq(generation.id)
      end
  end  

  context 'destroying a generation' do
    it 'destroys the generation' do
      delete :destroy, params: { integration_id: integration.id, id: generation.id }
      expect(response).to be_successful
      expect(Generation.find_by(id: generation.id)).to be_nil
    end
  end

  describe "DELETE #destroy" do
    it "deletes the generation successfully and returns an empty response" do
      delete :destroy, params: { integration_id: integration.id, id: generation.id }
      expect(response).to be_successful
      expect(response.body).to eq("{}") 
      expect { Generation.find(generation.id) }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it "fails to delete a non-existent generation" do
      delete :destroy, params: { integration_id: integration.id, id: 0 }  
      expect(response).to have_http_status(:not_found)
    end
  end
end
