Rails.application.routes.draw do
  resources :users

  root "posts#index"

  resources :posts, except: [ :new, :edit ] do
    resources :comments, except: [ :new, :edit ]
  end

  post "/posts/:id/tag", controller: :posts, action: :link_tag
  delete "/posts/:id/tag", controller: :posts, action: :unlink_tag
  put "/posts/:id/tag", controller: :posts, action: :replace_tags

  resources :tags, except: [ :new, :edit]
end
