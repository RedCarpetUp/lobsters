class Collcomment < ActiveRecord::Base
  belongs_to :user
  belongs_to :application
  validates :application_id, presence: true
  #validates :is_auto, presence: true
  validates :user_id, presence: true, if: :notauto?
  validates :body_nomark, presence: true, length: {minimum:5, maximum: 140}

  def body_nomark=(des)
    self[:raw_body] = des.to_s.rstrip
    self.body = self.generated_markeddown_body
  end

  def body_nomark
    self[:raw_body]
  end

  def generated_markeddown_body
    Markdowner.to_html(self.body_nomark, { :allow_images => true })
  end

  private

  def notauto?
    !self.is_auto
  end

end