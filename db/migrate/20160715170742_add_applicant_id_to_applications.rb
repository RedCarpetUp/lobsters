class AddApplicantIdToApplications < ActiveRecord::Migration
  def change
    add_column :applications, :applicant_id, :integer
  end
end
