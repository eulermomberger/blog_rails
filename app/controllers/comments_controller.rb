class CommentsController < ApplicationController
  before_action :set_post
  before_action :set_comment, only: [:update, :show, :destroy]

  def index
    render json: @post.comments
  end

  def create
    @comment = @post.comments.new(comment_params)
    if @comment.save
      render json: @comment, status: :created
    else
      render json: @comment.errors, status: :unprocessable_entity
    end
  end

  def show
    render json: @comment
  end

  def update
    if @comment.update(comment_params)
      render json: @post.comments, status: :ok
    else
      render json: @comment.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @comment.destroy
    head :no_content
  end

  private
  def set_post
    @post = Post.find(params[:post_id])
  end

  def set_comment
    @comment = Comment.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:text)
  end
end
