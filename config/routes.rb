Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  match 'slack/:channel', to: 'endpoint#slack', via: [:get, :post]
end
