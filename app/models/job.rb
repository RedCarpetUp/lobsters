class Job < ActiveRecord::Base
  searchkick
  belongs_to :poster, class_name: "User"
  has_many :applications

  has_and_belongs_to_many :collaborators, :join_table => :collabjobs_collaborators, foreign_key: "collaborator_id", class_name: "User", association_foreign_key: "collabjob_id"

  validates :poster_id, presence: true
  validates_length_of :title, :in => 3..150
  validates  :title, presence: true
  validates_length_of :company_name, :in => 3..150
  validates  :company_name, presence: true
  validates_length_of :desc_nomark, :maximum => (64 * 1024), :minimum => 140
  validates  :desc_nomark, presence: true
  validates_length_of :location, :in => 3..60

  def desc_nomark=(des)
    self[:raw_desc] = des.to_s.rstrip
    self.desc = self.generated_markeddown_desc
  end

  def desc_nomark
    self[:raw_desc]
  end

  def generated_markeddown_desc
    Markdowner.to_html(self.desc_nomark, { :allow_images => true })
  end

end