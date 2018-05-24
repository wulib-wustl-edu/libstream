Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :resources, :videos, :music do
    collection do
      post :destroy_multiple
    end
  end

  get 'access_denied', to: 'resources#access_denied'
  root 'resources#home'
end
