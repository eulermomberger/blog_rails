class PostsController < ApplicationController
  def index
    @posts = Post.all()
    render("/posts/index")
  end
end
