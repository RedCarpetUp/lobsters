class Booking < ActiveRecord::Base
  belongs_to :requestor, :class_name => "User"#, :counter_cache => :students_count
  belongs_to :requestee, :class_name => "User"

  validate :validate_not_self
  #validate :validate_not_already

  with_options({on: :assignment}) do |u|
  	u.validates :booking_date, presence: true
  	u.validates :start_time, presence: true
  	u.validates :end_time, presence: true
  end

  def validate_not_self
  	if requestee_id == requestor_id
  		errors.add(:base, "You can't request meetup with yourself")
  	end
  end

  #def validate_not_already
  #  if self.new_record? and !Booking.where( :requestee_id => requestee_id, :requestor_id => requestor_id, :is_deleted => false ).empty?
  #		errors.add(:base, "Meetup already requested")
  #	 end
  #end

  def full_update(attributes)
    with_transaction_returning_status do
      assign_attributes(attributes)
      save(context: :assignment)
    end
  end

end