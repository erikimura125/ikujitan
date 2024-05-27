class UsersController < ApplicationController
  before_action :ensure_guest_user, only: [:edit]
  before_action :authenticate_user!, only: [:show]
  before_action :is_matching_login_user, only: [:edit, :update, :withdraw]

  def index
    @users = User.all
  end
  
  def show
    @user = User.find(params[:id])
    @posts = @user.posts
    @users_followings = @user.followings
    @users_followers = @user.followers
    likes = Like.where(user_id: @user.id).pluck(:post_id)
    @like_posts = Post.find(likes)
    @post = Post.find(likes)
    @currentUserEntry = Entry.where(user_id: current_user.id)
    @userEntry = Entry.where(user_id: @user.id)
    if @user.id == current_user.id
    else
      @currentUserEntry.each do |cu|
        @userEntry.each do |u|
          if cu.room_id == u.room_id then
            @isRoom = true
            @roomId = cu.room_id
          end
        end
      end
    end
    if @isRoom
    else
      @room = Room.new
      @entry = Entry.new
    end
  end

  def edit
    @user = User.find(params[:id])
  end
  
  def update
    @user = User.find(params[:id])
    if @user.update(user_params) 
      redirect_to user_path(current_user.id)
    else
      render :edit
    end
  end
  
  def withdraw
    @user = User.find(params[:id])
    @user.update(is_deleted: true)
    reset_session
    flash[:notice] = "退会処理を実行いたしました"
    redirect_to root_path
  end
  
  private
  
  def user_params
    params.require(:user).permit(:nick_name, :profile_image)
  end
  
  def ensure_guest_user
    @user = User.find(params[:id])
    if @user.guest_user?
      redirect_to user_path(current_user) , notice: "ゲストユーザーはプロフィール編集画面へ遷移できません。"
    end
  end  
  
  def set_user
    @user = User.find(params[:id])
  end
  
  def is_matching_login_user
    user = User.find(params[:id])
    unless user.id == current_user.id
      redirect_to posts_path
    end
  end
end