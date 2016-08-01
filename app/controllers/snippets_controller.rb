class SnippetsController < ApplicationController
  before_action :require_user

  ITEMS_PER_PAGE = 3

  before_action :set_organisation
  #before_action :set_snippet, only: [:edit, :update, :destroy]
  #before_action :require_same_user, only: [:edit, :update, :destroy]
  before_action :require_owner_or_member, only: [:index, :new, :create]

  def index

    @page = 1
    if params[:page].to_i > 0
      @page = params[:page].to_i
    end

    @title = "Snippets"
    @av_members = [["All", "all"]]
    @av_members = @av_members + @organisation.users.collect { |c| [c.username, c.id] }
    @av_members.push([@organisation.owner.username, @organisation.owner.id])

    @av_ids = @organisation.users.pluck(:id)
    @av_ids.push(@organisation.owner.id)

    @snippets = @organisation.snippets.where(is_deleted: false)

    if params[:sni].present? && params[:sni][:week_no].present?
      year_no = params[:sni][:week_no].first(4).to_i
      week_no = params[:sni][:week_no].last(2).to_i
      range_of_week = (Date.commercial(year_no, week_no)).beginning_of_day..(Date.commercial(year_no, week_no) + 6).end_of_day

      @snippets = @snippets.where(created_at: range_of_week )
    end

    if params[:person].present?
      if params[:person] != "all"
        @snippets = @snippets.where(user_id: params[:person])
      end
    end

    @snippets = @snippets.order('created_at desc')

    @snippets = @snippets.offset((@page - 1) * ITEMS_PER_PAGE).limit(ITEMS_PER_PAGE)

    #@snippets = @snippets.records.last((@jobs = Job.all.search(params[:query]).count) - ((@page - 1) * ITEMS_PER_PAGE) ).first(ITEMS_PER_PAGE)

  end

  def new
    @title = "New Snippet"
    @snippet = Snippet.new
  end

  def create
    @snippet = Snippet.new(snippet_params)
    @snippet.user = current_user
    @snippet.organisation = @organisation
    @snippet.is_deleted = false

    if @snippet.save 
      flash[:success] = "Snippet Created!"
      redirect_to organisation_snippets_path(@organisation)
    else
      render :new
    end
  end

  #def edit
  #  @title = "Edit Snippet"
  #end

  #def update
  #  if @snippet.update(snippet_params)
  #    flash[:success] = 'Updated Successfully!'
  #    redirect_to organisation_snippets_path(@organisation)
  #  else
  #    render :edit
  #  end
  #end

  #def destroy
  #  temporg = @snippet.organisation
  #  @snippet.is_deleted = true
  #  @snippet.save
  #  flash[:success] = 'Snippet Deleted'
  #  redirect_to organisation_snippets_path(temporg)
  #end

  private

    def set_snippet
      @snippet = @organisation.snippets.where(is_deleted: false).find(params[:id])
    end

    def set_organisation
      @organisation =  Organisation.where(:is_deleted => false).find(params[:organisation_id])
    end

    def require_same_user
      if user_signed_in?
        if current_user.id != @snippet.user_id
          flash[:error] = 'You are not allowed to do this action'
          redirect_to root_path
        end
      else
        flash[:error] = 'You are not allowed to do this action'
        redirect_to root_path
      end
    end

    def require_owner_or_member
      if user_signed_in?
        if (!@organisation.users.include?(current_user))&&(current_user != @organisation.owner)
            flash[:error] = 'You are not allowed to do this action'
            redirect_to root_path
        end
      else
        flash[:error] = 'You are not allowed to do this action'
        redirect_to root_path
      end
    end

    def snippet_params
      params.require(:snippet).permit(:body_nomark)
    end

end