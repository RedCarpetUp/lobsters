class OrganisationsController < ApplicationController
  before_action :require_user
  before_action :set_organisation, except: [:new, :create, :index]
  before_action :require_same_or_member_user, only: [:org_members_list, :show, :add_member, :add_member_to_rel, :remove_member]
  before_action :require_same_user, only: [:edit, :update, :destroy]

  def index
    @cur_url = "/organisations"
    @title = "Your Organisations"
    @ownorganisations = current_user.ownorganisations.where(is_deleted: false)
    @organisations = current_user.organisations.where(is_deleted: false)
  end

  def show
    @title = @organisation.name
  end

  def new
    @organisation = Organisation.new
    @title = "New Organisation"
  end

  def create
    @organisation = Organisation.new(organisation_params)
    @organisation.is_deleted = false
    @organisation.owner = current_user
    if @organisation.save
      flash[:success] = "Organisation Created!"
      redirect_to organisation_path(@organisation)
    else
      render :new
    end
  end

  def edit
    @title = "Edit Organisation"
  end

  def update
    if @organisation.update(organisation_params)
      flash[:success] = 'Updated Successfully!'
      redirect_to organisation_path(@organisation)
    else
      render :edit
    end
  end

  def destroy
    @organisation.is_deleted = true
    @organisation.save
    flash[:success] = 'Organisation Deleted'
    redirect_to root_path
  end

  def add_member
    @title = "Add Member"
  end

  def add_member_to_rel
    @new_member_user = User.where(:username => params[:name]).first
    if @new_member_user.nil?
      flash[:error] = 'No user by this username found'
      redirect_to organisation_path(@organisation)
    else
      if (@organisation.owner == @new_member_user)||(@organisation.users.include?(@new_member_user))
        flash[:error] = 'This user is an already a member'
        redirect_to organisation_path(@organisation) and return
      end
      @organisation.users << @new_member_user
      if @organisation.users.include?(@new_member_user)
        flash[:success] = 'Member added as successfully!'
        @organisation.users.each do |touser|
          MembersChange.notify("added", touser, @new_member_user, @organisation).deliver
        end
        redirect_to organisation_path(@organisation)
      else
        flash[:error] = 'User can\'t be added as member'
        redirect_to organisation_path(@organisation)
      end
    end
  end

  def org_members_list
    @title = "Members"
    @members_list = @organisation.users
  end

  def remove_member
    @rem_member_user = User.where(:id => params[:rem_id]).first
    if @rem_member_user.nil?
      flash[:error] = 'No user by this username found'
      redirect_to organisation_path(@organisation)
    else
      if !@organisation.users.include?(@rem_member_user)
        flash[:error] = 'This user is not a member'
        redirect_to organisation_path(@organisation) and return
      end
      @organisation.users.delete(@rem_member_user)
      if !@organisation.users.include?(@rem_member_user)
        flash[:success] = 'User removed from members successfully!'
        @organisation.users.each do |touser|
          MembersChange.notify("removed", touser, @rem_member_user, @organisation).deliver
        end
        MembersChange.notify("removed", @rem_member_user, @rem_member_user, @organisation).deliver
        redirect_to organisation_path(@organisation)
      else
        flash[:error] = 'User can\'t be removed'
        redirect_to organisation_path(@organisation)
      end
    end
  end

  private

    def set_organisation
      @organisation =  Organisation.where(:is_deleted => false).find(params[:id])
    end

    def require_same_user
      if user_signed_in?
        if (current_user != @organisation.owner)
          flash[:error] = 'You can only edit organisations you have created'
          redirect_to organisations_path
        end
      else
        flash[:error] = 'You can only edit organisations you have created'
        redirect_to organisations_path
      end
    end

    def require_same_or_member_user
      if user_signed_in?
        if (!@organisation.users.include?(current_user))&&(current_user != @organisation.owner)
          flash[:error] = 'You are not allowed this operation'
          redirect_to organisations_path
        end
      else
        flash[:error] = 'You are not allowed this operation'
        redirect_to organisations_path
      end
    end

    def organisation_params
      params.require(:organisation).permit(:name, :intro)
    end

end