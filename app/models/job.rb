class Job < ActiveRecord::Base
  searchkick
  belongs_to :poster, class_name: "User"
  has_many :applications

  validates :poster_id, presence: true
  validates_length_of :title, :in => 3..150
  validates  :title, presence: true
  validates_length_of :company_name, :in => 3..150
  validates  :company_name, presence: true
  validates_length_of :intro, :in => 3..150
  validates  :intro, presence: true
  validates_length_of :desc, :maximum => (64 * 1024), :minimum => 140
  validates  :desc, presence: true
  validates_length_of :skills_reqs, :maximum => (64 * 1024)
  validates_length_of :about_company, :maximum => (64 * 1024)
  validates_length_of :req_subs, :in => 3..150
  validates  :req_subs, presence: true
  validates_length_of :location, :in => 3..60
  validates :pay, numericality: { only_integer: true }

end