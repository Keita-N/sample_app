class Reservation < ActiveRecord::Base
  attr_accessible :lesson_id

  belongs_to :user, class_name:'User'
  belongs_to :lesson, class_name:'Lesson'

  validates :user_id, presence:true
  validates :lesson_id, presence:true
end
