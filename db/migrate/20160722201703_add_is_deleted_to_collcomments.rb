class AddIsDeletedToCollcomments < ActiveRecord::Migration
  def change
  	add_column :collcomments, :is_deleted, :integer
  end
end
