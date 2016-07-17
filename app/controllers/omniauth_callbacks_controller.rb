class OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def facebook
    # what if user has no email?try with such user and do something
    if request.env["omniauth.auth"].info.email.blank?
      redirect_to "/users/auth/facebook?auth_type=rerequest&scope=email" and return
    end
    @user = User.from_omniauth_facebook(request.env["omniauth.auth"])
    if @user.persisted?
      sign_in_and_redirect @user, :event => :authentication #this will throw if @user is not activated
      set_flash_message(:notice, :success, :kind => "Facebook") if is_navigational_format?
    else
      if session.key?(:invite_code)
        if !Invitation.where(:code => session[:invite_code]).nil?
          invitation = Invitation.where(:code => session[:invite_code]).first
          session.delete(:invite_code)
          if(invitation.email == @user.email)
            @user.invited_by_user_id = invitation.user_id
            @user.save
            invitation.destroy
            if @user.persisted?
              sign_in_and_redirect @user, :event => :authentication #this will throw if @user is not activated
              set_flash_message(:notice, :success, :kind => "Facebook") if is_navigational_format?
            else
              redirect_to root_path
              flash[:notice] = "We couldn't save your details"
            end
          else
            redirect_to root_path
            flash[:notice] = "This invite wasn't meant for you"
          end
        else
          redirect_to root_path #Most probably, this will never happen, still kept for check
          flash[:notice] = "You are not yet signed up"
        end
      else
        redirect_to root_path
        flash[:notice] = "You are not yet signed up"
      end
    end
  end

  def google_oauth2
    @user = User.from_omniauth_google(request.env["omniauth.auth"])
    if @user.persisted?
      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Google"
      sign_in_and_redirect @user, :event => :authentication
    else
      if session.key?(:invite_code)
        if !Invitation.where(:code => session[:invite_code]).nil?
          invitation = Invitation.where(:code => session[:invite_code]).first
          session.delete(:invite_code)
          if(invitation.email == @user.email)
            @user.invited_by_user_id = invitation.user_id
            @user.save
            invitation.destroy
            if @user.persisted?
              flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Google"
              sign_in_and_redirect @user, :event => :authentication
            else
              redirect_to root_path
              flash[:notice] = "We couldn't save your details"
            end
          else
            redirect_to root_path
            flash[:notice] = "This invite wasn't meant for you"
          end
        else
          redirect_to root_path #Most probably, this will never happen, still kept for check
          flash[:notice] = "You are not yet signed up"
        end
      else
        redirect_to root_path
        flash[:notice] = "You are not yet signed up"
      end
    end
  end

  def failure
    redirect_to root_path
  end

end