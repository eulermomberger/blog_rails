class CommentsController < ApplicationController
  before_action :authorize_request, except: [:index, :show]
  before_action :set_post
  before_action :set_comment, only: [:update, :show, :destroy, :add_comment, :remove_comment, :update_comment, :get_comments, :show_comment]

  def index
    render json: @post.comments.list_all
  end

  def create
    @comment = @post.comments.new(comment_params)
    if @comment.save
      render json: @comment.list, status: :created
    else
      render json: @comment.errors, status: :unprocessable_entity
    end
  end

  def show
    @comment = Comment.where(post_id: params[:post_id])
    render json: @comment.list_all
  end

  def update
    if comment_params[:user_id] == @current_user.id
      if @comment.update(comment_params)
        render json: @post.comments, status: :ok
      else
        render json: @comment.errors, status: :unprocessable_entity
      end
    else
      render json: { error: 'unauthorized' }, status: :unauthorized
    end
  end

  def destroy
    if @comment.user == @current_user
      @comment.comments.delete_all
      @comment.destroy
      head :no_content
    else
      render json: { error: 'unauthorized' }, status: :unauthorized
    end
  end

  def add_comment
    @comment = @comment.comments.new(comment_params)
    if @comment.save
      render json: @comment.show, status: :created
    else
      render json: @comment.errors, status: :unprocessable_entity
    end
  end

  def remove_comment
    @comment.destroy
    head :no_content
  end

  def get_comments
    render json: @comment.comments
  end

  def show_comment
    render json: @comment.show
  end

  def update_comment
    if @comment.update(comment_params)
      render json: @comment, status: :ok
    else
      render json: @comment.errors, status: :unprocessable_entity
    end
  end

  private
  def set_post
    @post = Post.find(params[:post_id])
  end

  def set_comment
    @comment = Comment.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:text, :user_id)
  end
end
