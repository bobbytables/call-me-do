Rails.application.routes.draw do
  resources :calls do
    collection do
      get :menu
      post :menu, action: 'handle_menu'
    end
  end
end
