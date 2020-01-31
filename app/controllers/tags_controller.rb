class TagsController < ApplicationController
  before_action :authorize_request, except: [:index, :show]
  before_action :set_tags, only: [ :show, :update, :destroy]

  def index
    render json: Tag.list
  end

  def create
    @tag = Tag.new(tags_params)
    if @tag.save
      render json: @tag.index_info, status: :created
    else
      render json: @tag.errors, status: :unprocessable_entity
    end
  end

  def show
    render json: @tag
  end

  def update
    if @tag.update(tags_params)
      render json: @tag.index_info, status: :ok
    else
      render json: @tag.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @tag.destroy
    head :no_content
  end

  private
  def tags_params
    params.require(:tag).permit(:name)
  end

  def set_tags
    @tag = Tag.find(params[:id])
  end
end
