Rails.application.routes.draw do
  resources :calls do
    collection do
      get :menu
      post :menu_option_select
      get :droplet_regions
      post :select_droplet_region
      get :droplet_sizes
      post :select_droplet_size

      post :create_droplet
    end
  end
end
