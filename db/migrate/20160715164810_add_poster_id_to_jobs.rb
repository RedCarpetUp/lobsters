class AddPosterIdToJobs < ActiveRecord::Migration
  def change
    add_column :jobs, :poster_id, :integer
  end
end
