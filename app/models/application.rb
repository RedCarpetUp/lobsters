class Application < ActiveRecord::Base
  belongs_to :job
  belongs_to :applicant, class_name: "User"

  if Rails.application.config.anon_apply != true
    validates :applicant_id, presence: true
    validates :applicant_id, uniq_app: true, if: :is_new?
  end
  validates :job_id, presence: true
  validates_length_of :name, :in => 3..60
  validates :name, presence: true
  validates :email, :format => { :with => /\A[^@ ]+@[^@ ]+\.[^@ ]+\Z/ }, presence: true
  validates :phoneno, presence: true, length: { is: 10 }, format: { with: /(\+\d{1,2}\s)?\(?\d{3}\)?[\s.-]?\d{3}[\s.-]?\d{4}/ }, presence: true
  validates_length_of :details_nomark, :maximum => (64 * 1024)
  validates :details_nomark, presence: true
  validates_inclusion_of :status, :in => ["Shortlisted", "Applied", "Rejected", "Hired" ]
  validates :status, presence: true

  def is_new?
    self.new_record? ? true : false
  end

  def av_status
    case self.status
    when "Applied"
      return ["Shortlisted", "Rejected", "Hired"]
    when "Shortlisted"
      return ["Rejected", "Hired"]
    when "Hired"
      return []
    when "Rejected"
      return []
    end
        
  end

  def details_nomark=(des)
    self[:raw_details] = des.to_s.rstrip
    self.details = self.generated_markeddown_details
  end

  def details_nomark
    self[:raw_details]
  end

  def generated_markeddown_details
    Markdowner.to_html(self.details_nomark, { :allow_images => true })
  end
  
end