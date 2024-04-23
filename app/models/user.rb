class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
         
  has_many :posts, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :active_relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  has_many :passive_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  has_many :followings, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower
  
  has_one_attached :profile_image
  
  validates :nick_name, presence: true
  
  GUEST_USER_EMAIL = "guest@example.com"

  def self.guest
    find_or_create_by!(email: GUEST_USER_EMAIL) do |user|
      user.password = SecureRandom.urlsafe_base64
      user.nick_name = "guestuser"
      user.family_name = "guestuser"
      user.first_name = "guestuser"
      user.family_name_kana = "guestuser"
      user.first_name_kana = "guestuser"
    end
  end
  
  def guest_user?
    email == GUEST_USER_EMAIL
  end
  
  def active_for_authentication?
    super && (is_deleted == false)
  end

  def get_profile_image(width, height)
    unless profile_image.attached?
      file_path = Rails.root.join('app/assets/images/no_image.jpg')
      profile_image.attach(io: File.open(file_path), filename: 'default-image.jpg', content_type: 'image/jpeg')
    end
    profile_image.variant(resize_to_limit: [100, 100]).processed
  end
  
  def follow(user)
    active_relationships.create(followed_id: user.id)
  end
  
  def unfollow(user)
    active_relationships.find_by(followed_id: user.id).destroy
  end
  
  def following?(user)
    followings.include?(user)
  end
  
  def self.looks(search, word)
    if search == "perfect"
      @user = User.where("nick_name LIKE?", "#{word}")
    elsif search == "forward"
      @user = User.where("nick_name LIKE?", "#{word}%")
    elsif search == "backward"
      @user = User.where("nick_name LIKE?", "%#{word}")
    elsif search == "partial"
      @user = User.where("nick_name LIKE?", "%#{word}%")
    else
      @user = User.all
    end
  end
end