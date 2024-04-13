class Like < ApplicationRecord
  
  belong_to :user
  belong_to :post
  
  validates :user_id, uniqueness: {scope: :post_id}
  
end
