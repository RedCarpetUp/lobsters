class AddChangeIsDeletedType < ActiveRecord::Migration
  def change
  	remove_column :jobs, :is_deleted
  	remove_column :collcomments, :is_deleted
  	remove_column :applications, :is_deleted
  	add_column :jobs, :is_deleted, :boolean
  	add_column :collcomments, :is_deleted, :boolean
  	add_column :applications, :is_deleted, :boolean
  end
end
