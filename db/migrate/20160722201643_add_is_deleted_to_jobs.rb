class AddIsDeletedToJobs < ActiveRecord::Migration
  def change
  	add_column :jobs, :is_deleted, :integer
  end
end
