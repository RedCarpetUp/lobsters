class SignupController < ApplicationController
  before_filter :require_logged_in_user, :only => :invite

  def index
    if @user
      flash[:error] = "You are already signed up."
      return redirect_to "/"
    end

    @title = "Signup"
  end

  def invite
    @title = "Pass Along an Invitation"
  end

  def invited
    if @user
      flash[:error] = "You are already signed up."
      return redirect_to "/"
    end

    if !(@invitation = Invitation.where(:code => params[:invitation_code].to_s).first)
      flash[:error] = "Invalid or expired invitation"
      return redirect_to "/signup"
    end

    @title = "Signup"

    #logger.debug "DEADBEEFpreass: #{session[:invite_code]}"
    session[:invite_code] = params[:invitation_code].to_s
    #logger.debug "DEADBEEFpostass: #{session[:invite_code]}"

    @new_user = User.new
    @new_user.email = @invitation.email

    render :action => "invited"
  end

  def signup
    if !(@invitation = Invitation.where(:code => params[:invitation_code].to_s).first)
      flash[:error] = "Invalid or expired invitation."
      return redirect_to "/signup"
    end

    @title = "Signup"
    #no password complexity check?
    @new_user = User.new(user_params)
    @new_user.invited_by_user_id = @invitation.user_id

    if @new_user.save
      @invitation.destroy
      #session[:u] = @new_user.session_token
      sign_in @new_user
      flash[:success] = "Welcome to #{Rails.application.name}, " <<
        "#{@new_user.username}!"

      Countinual.count!("#{Rails.application.shortname}.users.created", "+1")
      Countinual.count!("#{Rails.application.shortname}.users.total",
        User.count)

      return redirect_to "/signup/invite"
    else
      render :action => "invited"
    end
  end

private
  def user_params
    params.require(:user).permit(
      :username, :email, :password, :password_confirmation, :about,
    )
  end
end
