class Integrations::SallaController < ApplicationController
  before_action :authenticate_user!, except: [:callback]

    def install

      url = "https://accounts.salla.sa/oauth2/auth"
      scope = "offline_access"
      auth_url = Integrations::Install.call(api_key: ENV["SALLA_CLIENT_ID"], redirect_uri: ENV["SALLA_REDIRECT_URI"], auth_token: request.headers['Authorization'], url: url, scope: scope,client_id: params[:client_id], other_params: "")
      render json: {url: auth_url.url} 
    end

  end