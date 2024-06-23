class LikesController < ApplicationController
  
  def create
    @post_like = Like.new(user_id: current_user.id,post_id: params[:post_id])
    if @post_like.save
    #result = [done: "save",user_id: current_user.id, post_id: params[:post_id]]
      @post_like.create_notification_like!(current_user)
      redirect_to post_path(params[:post_id]), notice: 'いいねしました'
    else
      redirect_to post_path(params[:post_id]), alert: 'いいねに失敗しました'
    end
  end
  
  def destroy
    @post_like = Like.find_by(user_id: current_user.id, post_id: params[:post_id])
    @post_like.destroy
    #result = [done: "destroy",user_id: current_user.id, post_id:params[:post_id]]
    redirect_to post_path(params[:post_id])
  end
end
