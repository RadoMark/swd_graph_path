Rails.application.routes.draw do
  root to: "home#index"

  post :upload, to: "home#upload"
  post :manage_edges, to: "edges#manage_edges"
  post :find_path, to: "nodes#find_path"
  get :generate_random_edges, to: "edges#generate_random_edges"

  resources :edges, only: [:destroy]
  resources :nodes, only: [:destroy]
end
