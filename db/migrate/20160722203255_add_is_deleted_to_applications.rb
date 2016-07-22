class AddIsDeletedToApplications < ActiveRecord::Migration
  def change
  	add_column :applications, :is_deleted, :integer
  end
end
