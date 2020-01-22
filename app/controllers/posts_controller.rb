class PostsController < ApplicationController
  before_action :set_post, only: [:show, :update, :destroy, :link_tag, :unlink_tag, :replace_tags]
  before_action :set_tags, only: [:create, :replace_tags, :link_tag, :unlink_tag]

  def index
    if params[:comment].nil? && params[:tag].nil? && params[:title].nil? && params[:description].nil?
      render json: Post.paginate(page: params[:page], per_page: 9).list
    elsif params[:title]
      render json: Post.where(title: params[:title]).paginate(page: params[:page], per_page: 9).list
    elsif params[:description]
      render json: Post.where(description: params[:description]).paginate(page: params[:page], per_page: 9).list
    elsif params[:comment]
      comment = Comment.where(text: params[:comment])
      render json: Post.where(id: comment.select(:post_id)).paginate(page: params[:page], per_page: 9).list
    elsif params[:tag]
      tag = Tag.where(name: params[:tag])
      @post = Post.joins(:tags).where(tags: {id: tag.select(:id)}).paginate(page: params[:page], per_page: 9).list
      render json: @post
    end
  end

  def create
    @post = Post.new(post_params)
    if @post.save
      link_tag
      render json: @post, status: :created
    else
      render json: @post.errors, status: :unprocessable_entity
    end
  end

  def show
    render json: @post.index_info
  end

  def update
    if @post.update(post_params)
      render json: @post.index_info, status: :ok
    else
      render json: @post.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @post.comments.delete_all
    @post.destroy
    head :no_content
  end

  def link_tag
    @tags.each do |tag|
      @post.check_tag(tag)
      @post.tags.push(tag)
    end
  end

  def unlink_tag
    @post.tags.delete(@tag)
  end

  def replace_tags
    @post.tags.delete_all
    @tags.each do |tag|
      @post.tags.push(tag)
    end
    render json: @post.tags.list, status: :ok
  end

  private
  def set_post
    @post = Post.find(params[:id])
  end

  def set_tags
    @tags = Tag.where(id: params[:tag_ids])
  end

  def post_params
    params.require(:post).permit(:title, :description, :user_id, :tag_ids => [])
  end

  def tag_params
    params.require(:post).permit(:tag_ids => [])
  end

end
