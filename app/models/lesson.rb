class Lesson < ActiveRecord::Base
  attr_accessible :ending, :name, :start

  validates :name, presence: true, uniqueness: true
  validates :start, presence: true
  validates :ending, presence: true
  validate :start_must_be_before_ending

  def start_must_be_before_ending
  	if self.start && self.ending
	  	errors.add(:ending, "mest be after start time") unless self.start < self.ending
	  end
  end
end
