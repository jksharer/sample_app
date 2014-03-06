class Micropost < ActiveRecord::Base
  belongs_to :user
  default_scope -> { order('created_at DESC') }
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }

  def self.from_users_followed_by(user)
    #下面三行作用相同，下面两行是rails提供的更为抽象的办法
    # followed_user_ids = user.followed_users.map { |followed| followed.id }
    # followed_user_ids = user.followed_users.map(&:id)
    # followed_user_ids = user.followed_user_ids   
    # Micropost.where("user_id in (?) OR user_id = ?", followed_user_ids, user)  性能会出现问题   
    
    followed_user_ids = "SELECT followed_id FROM relationships WHERE follower_id = :user_id"
    where("user_id IN (#{ followed_user_ids }) OR user_id = :user_id", user_id: user.id)
  end
end
