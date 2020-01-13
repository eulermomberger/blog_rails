class PostsController < ApplicationController
  before_action :set_post, only: [:show, :update, :destroy, :link_tag, :unlink_tag, :replace_tags]
  before_action :set_tag, only: [:link_tag, :unlink_tag]
  before_action :set_tags, only: [:replace_tags]

  def index
    @post = Post.list
    if params[:comment].nil? && params[:tag].nil? && params[:title].nil? && params[:description].nil?
      render json: @post
    elsif params[:title]
      render json: Post.where(title: params[:title]).paginate(page: params[:page], per_page: 10).list
    elsif params[:description]
      render json: Post.where(description: params[:description]).paginate(page: params[:page], per_page: 10).list
    elsif params[:comment]
      comment = Comment.where(text: params[:comment])
      render json: Post.where(id: comment.select(:post_id)).paginate(page: params[:page], per_page: 10).list
    elsif params[:tag]
      tag = Tag.where(name: params[:tag])
      render json: Post.preload(tag).all.map do |a|

      end
    end
  end

  def create
    @post = Post.new(post_params)
    if @post.save
      render json: @post, status: :created
    else
      render json: @post.errors, status: :unprocessable_entity
    end
  end

  def show
    render json: @post.show
  end

  def update
    if @post.update(post_params)
      render json: @post.index_info, status: :ok
    else
      render json: @post.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @post.destroy
    head :no_content
  end

  def link_tag
    @post.tags.push(@tag)
    render json: @post.tags.index_info, status: :ok
  end

  def unlink_tag
    @post.tags.delete(@tag)
    head :no_content
  end

  def replace_tags
    @post.tags.delete_all
    @tags.each do |tag|
      @post.tags.push(tag)
    end
    render json: @post.tags.index_info, status: :ok
  end

  private
  def set_post
    @post = Post.find(params[:id])
  end

  def set_tag
    @tag = Tag.find(tag_params[:tag_id])
  end

  def set_tags
    @tags = Tag.where(id: tag_params[:tag_ids])
  end

  def post_params
    params.require(:post).permit(:title, :description, :tag_id, :tag_ids => [])
  end

  def tag_params
    params.require(:post).permit(:tag_id, :tag_ids => [])
  end

end
