# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  email      :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class User < ActiveRecord::Base
  attr_accessible :email, :name, :password, :password_confirmation, :login_name, :state
  has_secure_password
  has_many :microposts, dependent: :destroy
  has_many :relationships, foreign_key: "follower_id", dependent: :destroy
  has_many :followed_users, through: :relationships, source: :followed
  has_many :reverse_relationships, foreign_key: "followed_id",
                class_name: "Relationship", dependent: :destroy
  has_many :followers, through: :reverse_relationships, source: :follower
  has_many :reply_to, through: :microposts, source: :reply_to

  has_many :reservations, dependent: :destroy

  before_save { |user| user.email = email.downcase }
  before_save :create_remember_token

  validates :name, presence: true, length: {maximum: 50}
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }
  validates :password, length: {minimum: 6}, on: :registration
  validates :password_confirmation, presence:true, on: :registration
  validates :login_name, presence:true, uniqueness: { case_sensitive: false}

  state_machine :state, initial: :standby do
    state :standby
    state :active

    event :change_state do
      transition to: :active, from: :standby
    end
  end

  def feed
    Micropost.from_users_followed_by(self)
  end

  def following?(other_user)
    relationships.find_by_followed_id(other_user.id)
  end

  def follow!(other_user)
    relationships.create!(followed_id:other_user.id)
  end

  def unfollow!(other_user)
    relationships.find_by_followed_id(other_user.id).destroy
  end

  def send_password_reset
    generate_token(:password_reset_token)
    self.password_reset_sent_at = Time.zone.now
    save!(validate:false)
    UserMailer.password_reset(self).deliver
  end

  def send_activate_account
    UserMailer.activate_account(self).deliver
  end

  def reserve!(lesson, part_type)
    reservations.create!(lesson_id:lesson.id, part_type:part_type)
  end

  def reserving?(lesson)
    reservations.find_by_lesson_id(lesson.id)
  end

  def cancel!(lesson)
    reservations.find_by_lesson_id(lesson.id).destroy
  end
  
  private

	  def create_remember_token
      generate_token(:remember_token)
	  end

    def generate_token(column)
      begin
        self[column] = SecureRandom.urlsafe_base64
      end while User.exists?(column => self[column])
    end
end
