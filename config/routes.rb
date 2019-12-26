Rails.application.routes.draw do
  devise_for :users
  root 'blogs#index'

  get '/new'    => 'blogs#new'
  post '/write' => 'blogs#create'

  devise_scope :user do
    get 'users/sign_out' => 'devise/sessions#destroy'
  end
end
