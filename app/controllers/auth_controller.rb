class AuthController < ApplicationController

  def social_login
    code = params[:code]
    provider = params[:provider]
    email = params[:email]
    id = params[:id] #provider id to validate with it later
    name = params[:name]
    # Retrive access token with Facebook API
    validator = AuthTokenValidator.validate(code, provider, id)

    if validator == true
      user = User.from_omniauth(provider, email, name)
      if user.persisted?
        sign_in(user)
        response.headers['Authorization'] = request.env['warden-jwt_auth.token']
        render json: user
      else
        render json: user.errors, status: :unprocessable_entity
      end
    else
      # Handle invalid Facebook token
      render json: validator, status: :unprocessable_entity
    end
  end
end

  