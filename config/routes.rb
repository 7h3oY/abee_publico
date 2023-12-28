Rails.application.routes.draw do
  resources :tokens
  resources :conexiones_marketplaces
  root "cambio_inventarios#index"
  resources :cambio_inventarios


  get 'inventarios',         action: :index,                controller: 'cambio_inventarios'
  get 'conexiones_pendientes',         action: :realizar_conexiones_pendientes,                controller: 'conexiones_marketplaces'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
