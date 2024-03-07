class Book < ApplicationRecord

  #投稿・コメント・いいね機能
  belongs_to :user
  has_many :book_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy

  #1週間のいいね降順
  has_many :week_favorites, -> { where(created_at: 1.week.ago.beginning_of_day..Time.current.end_of_day) }

  #閲覧数
  has_many :view_counts, dependent: :destroy

  validates :title, presence: true
  validates :body, presence: true, length: { maximum: 200 }
  
  #Bookのいいね状況を確認するメソッド
  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end
  
  #検索機能(Book)
  def self.search_for(content, method)
    if method == 'perfect'
      Book.where(title: content)
    elsif method == 'forward'
      Book.where('title LIKE ?', content + '%')
    elsif method == 'backward'
      Book.where('title LIKE ?', '%'+content)
    else
      Book.where('title LIKE ?', '%'+content+'%')
    end
  end
  

end
