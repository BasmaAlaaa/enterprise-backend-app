class AuthTokenValidator
    include HTTParty

    def self.validate(token, provider, uid)
        if provider == "facebook"
          response = HTTParty.get("https://graph.facebook.com/v14.0/debug_token?input_token=#{token}&access_token=#{ ENV['FACEBOOK_APP_ID']}|#{ ENV['FACEBOOK_APP_SECRET']}")
          if response.code == 200 && response["data"]["user_id"] == uid
            return true
          else 
            return response
          end
        elsif provider == "google"
          response = HTTParty.get("https://www.googleapis.com/oauth2/v3/tokeninfo?access_token=#{token}")
          if response.code == 200 && response["sub"] == uid
            return true
          else 
            return response
          end
        end
    end
  end
  