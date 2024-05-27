class PostsController < ApplicationController
  before_action :is_matching_login_user, only: [:edit, :update, :destroy]

  
  def new
    @post = Post.new
  end
  
  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id
    if @post.save
      redirect_to post_path(@post.id)
    else
      render :new
    end
  end
  
  def index
    if  params[:category]
      @posts = Post.where(category: params[:category])
    else
      @posts = Post.all
    end
  end

  def show
    @posts = Post.find(params[:id])
    @comment = Comment.new
  end
  
  def destroy
    post = Post.find(params[:id])
    post.destroy
    redirect_to posts_path
  end
  
  def edit
    @post = Post.find(params[:id])
  end
  
  def update
    @post = Post.find(params[:id])
    if @post.update(post_params)
    redirect_to post_path(@post.id)
    else
      render :edit
    end
  end
  
  
  private
  
  def post_params
    params.require(:post).permit(:image, :title, :body, :category)
  end
  
  def is_matching_login_user
    @post = Post.find(params[:id])
    unless @post.user.id == current_user.id
      redirect_to posts_path
    end
  end

end