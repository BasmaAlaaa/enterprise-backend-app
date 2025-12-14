# Rails.application.config.middleware.use OmniAuth::Builder do
#     provider :google_oauth2, ENV['GOOGLE_CLIENT_ID'], ENV['GOOGLE_CLIENT_SECRET']
#     provider :facebook, ENV['FACEBOOK_APP_ID'], ENV['FACEBOOK_APP_SECRET']
#     provider :google_oauth2, ENV['GOOGLE_ADS_CLIENT_ID'], ENV['GOOGLE_ADS_CLIENT_SECRET'], {
#     scope: ['email', 'profile', 'https://www.googleapis.com/auth/webmasters.readonly'],
#     access_type: 'offline',
#     prompt: 'consent',
#     redirect_uri: ENV['GOOGLE_REDIRECT_URI']
#   }
#   end
#   OmniAuth.config.allowed_request_methods = %i[get]