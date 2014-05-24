class Micropost < ActiveRecord::Base
  attr_accessible :content

  belongs_to :user
  belongs_to :reply_to, class_name:"User"

  validates :user_id, presence:true
  validates :content, presence:true, length:{maximum:140}

  default_scope order: 'microposts.created_at DESC'

  before_save :in_reply_to

  def self.from_users_followed_by(user)
  	followed_user_ids = "SELECT followed_id FROM relationships
                     WHERE follower_id = :user_id"
  	where("(user_id IN (#{followed_user_ids}) AND reply_to_id IS NULL)
        OR user_id = :user_id 
        OR reply_to_id = :user_id", user_id:user)
  end

  def in_reply_to
    if (self.content =~ /@[\w-]+/)      
      self.reply_to = User.find_by_login_name($&.tr('@', ''))
    end
  end

end
