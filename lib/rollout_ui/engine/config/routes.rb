RolloutUi::Engine.routes.draw do
  resources :features, :only => [:index, :update]
  resources :collections, :only => [:index, :create, :update]

  root :to => "features#index"
end
