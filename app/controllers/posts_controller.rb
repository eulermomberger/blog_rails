class PostsController < ApplicationController
  before_action :authorize_request, except:[:index, :show]
  before_action :set_post, only: [:show, :update, :destroy, :link_tag, :unlink_tag, :replace_tags]
  before_action :set_tags, only: [:create, :update, :replace_tags, :link_tag, :unlink_tag]

  def index
    if params[:comment].nil? && params[:tag].nil? && params[:title].nil? && params[:description].nil?
      render json: Post.list
    elsif params[:title]
      render json: Post.where(title: params[:title]).list
    elsif params[:description]
      render json: Post.where(description: params[:description]).list
    elsif params[:comment]
      comment = Comment.where(text: params[:comment])
      render json: Post.where(id: comment.select(:post_id)).list
    elsif params[:tag]
      tag = Tag.where(name: params[:tag])
      @post = Post.joins(:tags).where(tags: {id: tag.select(:id)}).list
      render json: @post
    end
  end

  def create
    @post = Post.new(post_params)
    @post.user.increment(:number_of_posts, 1).save
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
    if post_params[:user_id] == @current_user.id
      replace_tags
      if @post.update(post_params)
        render json: @post.index_info, status: :ok
      else
        render json: @post.errors, status: :unprocessable_entity
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
    if @post.user == @current_user
      destroy_comments(@post.comments)
      @post.user.decrement(:number_of_posts, 1).save
      @post.destroy
      head :no_content
    else
      render json: { error: 'unauthorized' }, status: :unauthorized
    end
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
