class Application < ActiveRecord::Base
  belongs_to :job
  belongs_to :applicant, class_name: "User"

  validates :applicant_id, presence: true, uniqueness: true
  validates :job_id, presence: true
  validates_length_of :name, :in => 3..60, presence: true
  validates :email, :format => { :with => /\A[^@ ]+@[^@ ]+\.[^@ ]+\Z/ }, presence: true
  validates :phoneno, presence: true, length: { is: 10 }, format: { with: /(\+\d{1,2}\s)?\(?\d{3}\)?[\s.-]?\d{3}[\s.-]?\d{4}/ }, presence: true
  validates_length_of :details, :maximum => (64 * 1024), presence: true
  validates_inclusion_of :status, :in => ["Shortlisted", "Applied", "Rejected", "Hired" ], presence: true

  def mod_status(new_status)

    case self.status
    when "Applied"
      if new_status == "Shortlisted"
        self.status = new_status
        if self.save
          return { result => "success", statement => "Status updated successfully" }
        else
          return { result => "failure", statement => "Status can't be updated" }
        end
      elsif new_status == "Hired"
        self.status = new_status
        if self.save
          return { result => "success", statement => "Status updated successfully" }
        else
          return { result => "failure", statement => "Status can't be updated" }
        end
      elsif new_status == "Rejected"
        self.status = new_status
        if self.save
          return { result => "success", statement => "Status updated successfully" }
        else
          return { result => "failure", statement => "Status can't be updated" }
        end
      else
        return { result => "failure", statement => "Status can't be updated" }
      end
    when "Shortlisted"
      if new_status == "Hired"
        self.status = new_status
        if self.save
          return { result => "success", statement => "Status updated successfully" }
        else
          return { result => "failure", statement => "Status can't be updated" }
        end
      elsif new_status == "Rejected"
        self.status = new_status
        if self.save
          return { result => "success", statement => "Status updated successfully" }
        else
          return { result => "failure", statement => "Status can't be updated" }
        end
      else
        return { result => "failure", statement => "Status can't be updated" }
      end
    when "Hired"
      return { result => "failure", statement => "Status can't be updated" }
    when "Rejected"
      return { result => "failure", statement => "Status can't be updated" }
    end
        
  end
  
end