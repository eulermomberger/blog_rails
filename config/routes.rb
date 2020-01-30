Rails.application.routes.draw do
  resources :users, param: :_username

  post '/auth/login', to: 'authentication#login'

  resources :posts, except: [ :new, :edit ] do
    resources :comments, except: [ :new, :edit ]
  end

  post "/posts", controller: :posts, action: :link_tag
  delete "/posts/:id", controller: :posts, action: :unlink_tag
  put "/posts/:id", controller: :posts, action: :replace_tags

  get "/posts/:post_id/comments/:id/comments", controller: :comments, action: :get_comments
  get "/posts/:post_id/comments/:comment_id/comments/:id", controller: :comments, action: :show_comment
  post "/posts/:post_id/comments/:id/comments", controller: :comments, action: :add_comment
  delete "/posts/:post_id/comments/:comment_id/comments/:id", controller: :comments, action: :remove_comment
  put "/posts/:post_id/comments/:comment_id/comments/:id", controller: :comments, action: :update_comment

  resources :tags, except: [ :new, :edit]
end
