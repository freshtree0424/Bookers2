class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  #投稿・コメント・いいね機能
  has_many :books, dependent: :destroy
  has_many :book_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy

  #フォロー・フォロワー機能  
  has_many :follower, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  has_many :followed, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy 
  has_many :following_user, through: :follower, source: :followed 
  has_many :follower_user, through: :followed, source: :follower 

  #DM機能
  has_many :messages, dependent: :destroy
  has_many :entries, dependent: :destroy
  has_many :rooms, through: :entries

  #閲覧数
  has_many :view_counts, dependent: :destroy

  #バリテーション
  validates :name, length: { minimum: 2, maximum: 20 }, uniqueness: true
  validates :introduction, length: { maximum: 50 }

  has_one_attached :profile_image

  #ユーザーをフォローするメソッド
  def follow(user_id)
   follower.create(followed_id: user_id)
  end
  #ユーザーのフォローを外すメソッド
  def unfollow(user_id)
   follower.find_by(followed_id: user_id).destroy
  end
  #ユーザーのフォロー状況を確認するメソッド
  def following?(user)
   following_user.include?(user)
  end
  #プロフィール画像の確認を行うメソッド
  def get_profile_image
    (profile_image.attached?) ? profile_image : 'no_image.jpg'
  end

  #検索機能(User)
  def self.looks(search, word)
    if search == "perfect_match"
      @user = User.where("name LIKE?", "#{word}")
    elsif search == "forward_match"
      @user = User.where("name LIKE?","#{word}%")
    elsif search == "backward_match"
      @user = User.where("name LIKE?","%#{word}")
    elsif search == "partial_match"
      @user = User.where("name LIKE?","%#{word}%")
    else
      @user = User.all
    end
  end

end
