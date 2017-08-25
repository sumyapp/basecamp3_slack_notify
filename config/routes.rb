Rails.application.routes.draw do
  match 'slack/:channel', to: 'endpoint#slack', via: [:get, :post]

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
