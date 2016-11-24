class EditIsDeletedOfBookings < ActiveRecord::Migration
  def change
  	remove_column :bookings, :is_deleted
  	add_column :bookings, :is_deleted, :boolean
  end
end
