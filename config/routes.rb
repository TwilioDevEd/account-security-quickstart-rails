Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  namespace :api do
    # Locally and Authyly user creation
    post '/user/register', to: 'users#register'

    # Authentication API
    post '/login', to: 'authentication#login'
    post '/logout', to: 'authentication#logout'
    post '/loggedIn', to: 'authentication#loggedIn'

    # Account Security Authentication API
    post '/accountsecurity/sms', to: 'twofa#sms'
    post '/accountsecurity/voice', to: 'twofa#voice'
    post '/accountsecurity/verify', to: 'twofa#verify'
    post '/accountsecurity/onetouchstatus', to: 'twofa#onetouchstatus'
    post '/accountsecurity/onetouch', to: 'twofa#onetouch'

    # Account Security Phone Verification API
    post '/verification/start', to: 'verify#start'
    post '/verification/verify', to: 'verify#verify'
  end
end
