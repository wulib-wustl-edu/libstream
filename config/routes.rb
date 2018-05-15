Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :resources do
    collection do
      post :destroy_multiple
    end
  end

  root 'resources#home'
end
