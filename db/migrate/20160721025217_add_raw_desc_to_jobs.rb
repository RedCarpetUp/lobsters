class AddRawDescToJobs < ActiveRecord::Migration
  def change
    add_column :jobs, :raw_desc, :text
  end
end
