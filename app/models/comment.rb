class Comment < ApplicationRecord

  belongs_to :user
  belongs_to :post
  has_many :notifications, dependent: :destroy


  def create_notification_comment!(current_user, comment_id)
    save_notification_comment!(current_user, comment_id, post.user_id)
  end

  def save_notification_comment!(current_user, comment_id, visited_id)
    notification = current_user.active_notifications.new(
      post_id: post.id,
      comment_id: comment_id,
      visited_id: visited_id,
      action: 'comment'
      )
      if notification.visitor_id == notification.visited_id
        notification.checked = true
      end
      notification.save if notification.valid?
  end

end
