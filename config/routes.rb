Rails.application.routes.draw do
  namespace :api do
    post 'sign_up' => 'v1/sessions#sign_up'
    post 'login' => 'v1/sessions#login'
    post 'authByToken'=> 'v1/sessions#authByToken'
    namespace :v1 do 
      resources :posts , except: [:new,:edit]
    end
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
