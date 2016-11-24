class BookingsController < ApplicationController
	before_action :require_user
	before_action :set_booking, only: [:destroy, :edit, :update]
  	before_action :requestee_only, only: [:destroy, :edit, :update]
  	before_action :allowed_or_not_check, only: [:create]

	def index
		@title = "My bookings"
		@myaccepts = current_user.has_bookeds.where(:is_deleted => false)
		@myrequests = current_user.was_bookeds.where(:is_deleted => false)
	end

	def create
		@booking = Booking.new
		@booking.requestee = User.find(params[:requestee_id])
		@booking.requestor = current_user
		@booking.is_deleted = false
		if @booking.save
          	if Rails.application.config.side_mail == true
          	  BookingRequest.delay.notify(@booking.requestee, @booking.requestor)
          	else
          	  BookingRequest.notify(@booking.requestee, @booking.requestor).deliver
          	end
			flash[:success] = "Request to meetup sent"
			redirect_to user_path(User.find(params[:requestee_id]).username)
		else
			flash[:error] = "Request to meetup failed"
			redirect_to user_path(User.find(params[:requestee_id]).username)
		end
	end

	def destroy
		@booking.is_deleted = true
		if @booking.save
			flash[:success] = "Request to meetup declined"
			redirect_to bookings_path
		else
			flash[:error] = "Request to meetup couldn't be declined"
			redirect_to bookings_path
		end
	end

	def edit
		@title = "Assign slot"
	end

	def update
		if @booking.full_update(assign_params)
          	if Rails.application.config.side_mail == true
          	  BookingAssign.delay.notify(@booking.requestee, @booking.requestor, @booking)
          	else
          	  BookingAssign.notify(@booking.requestee, @booking.requestor, @booking).deliver
          	end
			flash[:success] = "Assigned slot successfully"
			redirect_to bookings_path
		else
      render :edit
		end

	end

	private

	def set_booking
		@booking = Booking.find(params[:id])
	end

  def assign_params
    params.require(:booking).permit(:booking_date, :start_time, :end_time)
  end

  def requestee_only
    if @booking.requestee != current_user
      flash[:error] = "You are not allowed this"
      redirect_to bookings_path
    end
  end 

  def allowed_or_not_check
  	if User.pluck(:id).include?(params[:requestee_id].to_i)
  		if current_user == User.find(params[:requestee_id]) and !Booking.where( :requestee_id => params[:requestee_id], :requestor_id => current_user.id, :is_deleted => false, :booking_date => nil ).empty?
      		flash[:error] = "You are not allowed this"
      		redirect_to bookings_path and return
  		end
  	else
    	flash[:error] = "You are not allowed this"
    	redirect_to bookings_path
  	end
  end

end