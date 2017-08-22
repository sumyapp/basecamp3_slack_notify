Rails.application.routes.draw do
  mount LetsencryptPlugin::Engine, at: '/'  # It must be at root level
  match 'slack/:channel', to: 'endpoint#slack', via: [:get, :post]

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
