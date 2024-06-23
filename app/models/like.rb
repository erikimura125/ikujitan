class Like < ApplicationRecord
  
  belongs_to :user
  belongs_to :post
  
  validates :user_id, uniqueness: {scope: :post_id}
  
  def create_notification_like!(current_user)
    temp = Notification.where(["visitor_id = ? and visited_id = ? and post_id = ? and action = ? ", current_user.id, post.user_id, post.id, 'like'])
    if temp.blank? && current_user.id != post.user_id
      notification = current_user.active_notifications.new(
        post_id: post.id,
        visited_id: post.user_id,
        action: 'like'
        )
        if notification.visitor_id == notification.visited_id
          notification.checked = true
        end
        notification.save if notification.valid?
    end
  end

end
