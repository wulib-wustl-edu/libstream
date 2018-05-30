Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :resources, :videos, :music do
    collection do
      post :destroy_multiple
    end
  end

  delete 'music/destroy_upload/:name', to: 'music#destroy_upload'
  delete 'videos/destroy_upload/:name', to: 'videos#destroy_upload'
  get 'access_denied', to: 'resources#access_denied'
  root 'resources#home'
end
