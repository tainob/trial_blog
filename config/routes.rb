Rails.application.routes.draw do
  devise_for :users
  root 'user_posts#index'

  get '/users',  to: 'user_posts#index'   #ログイン後
  get '/new'  ,  to: 'user_posts#new'     #ブログを書く
  post '/write', to: 'user_posts#create'  #ブログ保存
  get  "user_posts/:id/edit"    => 'user_posts#edit'    #ブログ再編集
  post "user_posts/:id/update"  => "user_posts#update"  #ブログ更新
  delete "user_posts/:id" => 'user_posts#destroy' #ブログ削除

  get '/list',   to: 'user_posts#list'    #他人のブログを表示（カテゴリ別）

  devise_scope :user do
    get 'users/sign_out' => 'devise/sessions#destroy'
  end

  resources :user_posts
end
