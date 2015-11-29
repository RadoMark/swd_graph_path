Rails.application.routes.draw do
  root to: "home#index"

  post :upload, to: "home#upload"
  post :manage_edges, to: "edges#manage_edges"
  post :find_path, to: "nodes#find_path"

  resources :edges, only: [:destroy]
  resources :nodes, only: [:destroy]
end
