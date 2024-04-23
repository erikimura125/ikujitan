class Post < ApplicationRecord
  
  has_one_attached :image
  belongs_to :user
  has_many :likes, dependent: :destroy
  has_many :comments, dependent: :destroy
  
  validates :title, presence: true
  validates :body, presence: true

  def get_image
    unless image.attached?
      file_path = Rails.root.join('app/assets/images/no_image.jpg')
      image.attach(io: File.open(file_path), filename: 'default-image.jpg', content_type: 'image/jpeg')
    end
    image
  end
  
  def liked?(user)
    likes.where(user_id: user.id).exists?
  end
  
  def self.search_for(content, method)
    if method == 'perfect'
     Post.where(title: content)
    elsif method == 'forward'
      Post.where('name LIKE ?', content + '%')
    elsif method == 'backward'
      Post.where('name LIKE ?', '%' + content)
    else
      Post.where('name LIKE ?', '%' + content + '%')
    end
  end
end