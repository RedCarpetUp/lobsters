class Application < ActiveRecord::Base
  include PgSearch
  #multisearchable :against => [:title, :company_name, :raw_desc]
  pg_search_scope :search_by_pg, :against => [:name, :email, :details]

  belongs_to :job
  belongs_to :applicant, class_name: "User"
  has_many :collcomments

  has_many :appl_questions

  if Rails.application.config.anon_apply != true
    validates :applicant_id, presence: true
    validates :applicant_id, uniq_app: true, if: :is_new?
  end

  #validates :is_referred, presence: true

  validates :job_id, presence: true
  validates_length_of :name, :in => 3..60
  validates :name, presence: true
  validates :email, :format => { :with => /\A[^@ ]+@[^@ ]+\.[^@ ]+\Z/ }, presence: true
  validates :phoneno_inp, phone: { types: [:mobile] }
  validates_length_of :details_nomark, :maximum => (64 * 1024)
  validates :details_nomark, presence: true
  validates_inclusion_of :status, :in => ["Shortlisted", "Applied", "Rejected", "Hired" ]
  validates :status, presence: true

  validates :referrer_name, presence: true, if: :by_referway?
  validates_length_of :referrer_name, :in => 3..60, if: :by_referway?
  validates :referrer_email, :format => { :with => /\A[^@ ]+@[^@ ]+\.[^@ ]+\Z/ }, presence: true, if: :by_referway?
  validates :referrer_phone_inp, phone: { types: [:mobile] }, presence: true, if: :by_referway?

  def is_new?
    self.new_record? ? true : false
  end

  def by_referway?
    self.is_referred ? true : false
  end

  def av_status
    case self.status
    when "Applied"
      return ["Shortlisted", "Rejected", "Hired", "Applied"]
    when "Shortlisted"
      return ["Rejected", "Hired", "Applied"]
    when "Hired"
      return ["Applied"]
    when "Rejected"
      return ["Applied"]
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
  
  def phoneno_inp=(des)
    self[:phoneno] = Phonelib.parse(des).international
  end

  def phoneno_inp
    self[:phoneno]
  end

  def referrer_phone_inp=(des)
    self[:referrer_phone] = Phonelib.parse(des).international
  end

  def referrer_phone_inp
    self[:referrer_phone]
  end

end