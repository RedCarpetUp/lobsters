class CreateBookings < ActiveRecord::Migration
  def change
    create_table :bookings do |t|
    	t.date :booking_date
    	t.time :start_time
    	t.time :end_time
    	t.integer :is_deleted
    	t.integer :requestor_id
    	t.integer :requestee_id
    	t.timestamps
    end
  end
end
