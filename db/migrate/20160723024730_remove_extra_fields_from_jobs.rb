class RemoveExtraFieldsFromJobs < ActiveRecord::Migration
  def change
    remove_column :jobs, :pay
    remove_column :jobs, :intro
    remove_column :jobs, :req_subs
  end
end
