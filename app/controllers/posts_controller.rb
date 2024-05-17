class PostsController < ApplicationController
  def new
    @post = Post.new
  end
  
  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id
    if @post.save
      redirect_to posts_path
    else
      render :new
    end
  end
  
  def index
    @posts = Post.all
  end
  
  def life
    @posts = Post.where(category: "life")
  end
  
  def cook
    @posts = Post.where(category: "cook")
  end
  
  def toy
    @posts = Post.where(category: "toy")
  end
  
  def show
    @posts = Post.find(params[:id])
    #if @posts.present?
      @comment = Comment.new
    #else
      #flash[:notice] = '指定された投稿が見つかりませんでした'
      #redirect_to posts_path 
    #end
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
  
end