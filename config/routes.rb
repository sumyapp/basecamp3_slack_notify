Rails.application.routes.draw do
  post 'slack/:channel', to: 'endpoint#slack', as: 'webhook'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
