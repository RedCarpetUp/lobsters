class AddIsClosedToJobs < ActiveRecord::Migration
  def change
  	add_column :jobs, :is_closed, :boolean
  end
end
