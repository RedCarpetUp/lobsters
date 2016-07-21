class RemoveFieldsFromJobs < ActiveRecord::Migration
  def change
  	remove_column :jobs, :about_company
  	remove_column :jobs, :skills_reqs
  end
end
