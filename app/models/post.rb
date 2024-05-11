class Post < ApplicationRecord
  
  has_one_attached :image
  belongs_to :user
  has_many :likes, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :notifications, dependent: :destroy
  
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
  
  def self.looks(search, word)
    if search == "perfect"
      @post = Post.where("title LIKE?","#{word}")
    elsif search == "forward"
      @post = Post.where("title LIKE?","#{word}%")
    elsif search == "backward"
      @post = Post.where("title LIKE?","%#{word}")
    elsif search == "partial"
      @post = Post.where("title LIKE?","%#{word}%")
    else
      @post = Post.all
    end
  end
  
    
end