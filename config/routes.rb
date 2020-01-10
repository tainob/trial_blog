Rails.application.routes.draw do
  devise_for :users
  root 'user_posts#index'

  get '/users',  to: 'user_posts#index'   #ログイン後
  get '/new'  ,  to: 'user_posts#new'     #ブログ入力
  post '/write', to: 'user_posts#create'  #ブログ保存
  get  "user_posts/:id/edit"    => 'user_posts#edit'    #ブログ再編集
  post "user_posts/:id/update"  => "user_posts#update"  #ブログ更新
  delete "user_posts/:id"       => 'user_posts#destroy' #ブログ削除

  get '/mylist', to: 'user_posts#mylist'  #自分のブログの一覧を表示（カテゴリ別）
  get '/list',   to: 'user_posts#list'    #他人のブログの一覧を表示（カテゴリ別）

  get  "comments/:id/new"   => 'comments#new'     #コメント入力
  post "comments/:id/write" => 'comments#create'  #コメント保存
  delete "comments/:id" => 'comments#destroy'     #コメント削除

  devise_scope :user do
    get 'users/sign_out' => 'devise/sessions#destroy'
  end

  resources :user_posts
  resources :comments
end
