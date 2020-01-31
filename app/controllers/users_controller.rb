class UsersController < ApplicationController
  before_action :authorize_request, except: [:create, :index, :show]
  before_action :set_user, except: %i[create index]

  def index
    @users = User.all
    render json: @users, status: :ok
  end

  def show
    render json: @user, status: :ok
  end

  def create
    @user = User.new(user_params)
    if @user.save
      render json: @user, status: :created
    else
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @user == @current_user
      if @user.update(user_params)
        render json: @user, status: :ok
      else
        render json: @user.errors, status: :unprocessable_entity
      end
    else
      render json: { error: 'unauthorized' }, status: :unauthorized
    end
  end

  def destroy_comments(comments)
    comments.each do |c|
      if c.comments
        destroy_comments(c.comments);
      end
      c.destroy;
    end
  end

  def destroy
    if @user == @current_user
      destroy_comments(@user.comments)
      destroy_comments(@user.posts)
      @user.comments.destroy_all;
      @user.posts.destroy_all;
      @user.destroy
      head :no_content
    else
      render json: { error: 'unauthorized' }, status: :unauthorized
    end
  end

  private
  def set_user
    @user = User.find_by_username!(params[:_username])
    rescue ActiveRecord::RecordNotFound
      render json: { errors: 'User not found' }, status: :not_found
  end

  def user_params
    params.permit(:name, :username, :email, :password, :password_confirmation)
  end
end
