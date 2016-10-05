class ApplQuestion < ActiveRecord::Base

  belongs_to :application, class_name: "Application"
  belongs_to :asker, class_name: "User"

  validates :application_id, presence: true
  validates :asker_id, presence: true

  validates  :question, presence: true
  validates  :answer_nomark, presence: true, if: :is_old?

  validates_length_of :question, :in => 3..60
  validates_length_of :answer_nomark, :maximum => (64 * 1024), if: :is_old?

  def answer_nomark=(des)
    self[:raw_answer] = des.to_s.rstrip
    self.answer = self.generated_markeddown_answer
  end

  def answer_nomark
    self[:raw_answer]
  end

  def generated_markeddown_answer
    Markdowner.to_html(self.answer_nomark, { :allow_images => true })
  end

  def is_old?
    !self.new_record? ? true : false
  end

end