Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  namespace :api do
    # Locally and Authyly user creation
    post '/user/register', to: 'application#register'

    # Authentication API
    post '/login', to: 'authentication#login'
    post '/logout', to: 'authentication#logout'
    post '/loggedIn', to: 'authentication#loggedIn'

    # Account Security Authentication API
    post '/api/accountsecurity/sms', to: 'twofa#sms'
    post '/api/accountsecurity/voice', to: 'twofa#voice'
    post '/api/accountsecurity/verify', to: 'twofa#verify'
    post '/api/accountsecurity/onetouchstatus', to: 'twofa#onetouchstatus'
    post '/api/accountsecurity/onetouch', to: 'twofa#onetouch'

    # Account Security Phone Verification API
    post '/api/verification/start', to: 'verify#start'
    post '/api/verification/verify', to: 'verify#verify'
  end
end
