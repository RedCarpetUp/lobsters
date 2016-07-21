class Collcomment < ActiveRecord::Base
  belongs_to :user
  belongs_to :application
  validates :application_id, presence: true
  validates :user_id, presence: true
  validates :body, presence: true, length: {minimum:5, maximum: 140 }

end