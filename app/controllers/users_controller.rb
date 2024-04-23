class UsersController < ApplicationController
  before_action :ensure_guest_user, only: [:edit]
  
  def index
    @users = User.all
  
  def show
    @user = User.find(params[:id])
    @posts = @user.posts
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
end
