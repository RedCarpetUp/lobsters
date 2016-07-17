class AddJobIdToApplications < ActiveRecord::Migration
  def change
    add_column :applications, :job_id, :integer
  end
end
