class AddApplicationIdToCollcomments < ActiveRecord::Migration
  def change
  	add_column :collcomments, :application_id, :integer
  end
end
