Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  resources :messages, param: :message_number, path: 'applications/:application_token/chats/:chat_number/messages',
                       constraints: { message_number: /\d+/ }
  resources :chats, param: :chat_number, path: 'applications/:application_token/chats',
                    constraints: { chat_number: /\d+/ }
  resources :chat_applications, path: 'applications', param: :application_token

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get 'up' => 'rails/health#show', as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
