class JobsController < ApplicationController
  before_action :require_user, only: [:job_collabs_list, :remove_collab, :edit, :update, :destroy, :new, :create, :add_collaborator, :user_applied_jobs, :user_jobs, :add_collaborator, :add_collaborator_to_rel]
  before_action :set_job, only: [:edit, :update, :show, :destroy, :add_collaborator, :add_collaborator_to_rel, :job_collabs_list, :remove_collab]
  before_action :require_same_or_collab_user, only: [:edit, :update, :destroy, :add_collaborator, :add_collaborator_to_rel]
  before_action :require_same_user, only: [:job_collabs_list, :remove_collab]
  before_action :set_user_from_name, only: [:user_applied_jobs, :user_jobs]
  before_action :require_same_user_from_name, only: [:user_applied_jobs, :user_jobs]

  ITEMS_PER_PAGE = 20

  def show
    @title = @job.title
  end

  def index

    @cur_url = "/jobs"
    @title = "Jobs"

    @page = 1
    if params[:page].to_i > 0
      @page = params[:page].to_i
    end

    if params[:query].present?
      @jobs = Job.where(is_deleted: false).search(params[:query]).records.last((@jobs = Job.all.search(params[:query]).count) - ((@page - 1) * ITEMS_PER_PAGE) ).first(ITEMS_PER_PAGE)
    else
      @jobs = Job.where(is_deleted: false).offset((@page - 1) * ITEMS_PER_PAGE).limit(ITEMS_PER_PAGE)
    end

  end

  def new
    @job = Job.new
    @title = "New Job"
  end

  def create
    @job = Job.new(job_params)
    @job.poster = current_user
    @job.is_deleted = false

    if @job.save
      flash[:success] = "Job Created!"
      redirect_to job_path(@job)
    else
      render :new
    end
  end

  def edit
    @title = "Edit Job"
  end

  def update
    if @job.update(job_params)
      flash[:success] = 'Updated Successfully!'
      redirect_to job_path(@job)
    else
      render :edit
    end
  end

  def destroy
    tempuser = @job.user
    @job.is_deleted = true
    @job.save
    flash[:success] = 'Job Deleted'
    redirect_to jobs_path
  end

  def user_jobs

    @page = 1
    if params[:page].to_i > 0
      @page = params[:page].to_i
    end

    @user_jobs = current_user.jobs.offset((@page - 1) * ITEMS_PER_PAGE).limit(ITEMS_PER_PAGE)
    @title = "Jobs"
  end

  def user_applied_jobs

    @page = 1
    if params[:page].to_i > 0
      @page = params[:page].to_i
    end

    @user_applications = Job.where(is_deleted: false).where(id: current_user.applications.pluck(:job_id).uniq).offset((@page - 1) * ITEMS_PER_PAGE).limit(ITEMS_PER_PAGE)
    @title = "Jobs"
  end

  def add_collaborator
    @title = "Add Collaborator"
  end

  def add_collaborator_to_rel
    @new_collab_user = User.where(:username => params[:name]).first
    if @new_collab_user.nil?
      flash[:error] = 'No user by this username found'
      redirect_to job_path(@job)
    else
      if (@job.poster == @new_collab_user)||(@job.applications.include?(@new_collab_user))
        flash[:error] = 'This user is an already a collaborator'
        redirect_to job_path(@job) and return
      end
      if @job.applications.pluck(:applicant_id).include?(@new_collab_user.id)
        flash[:error] = 'This user is an applicant for this job, hence can\'t collaborate in selection process'
        redirect_to job_path(@job) and return
      end
      @job.collaborators << @new_collab_user
      if @job.collaborators.include?(@new_collab_user)
        flash[:success] = 'User added as collaborator successfully!'
        redirect_to job_path(@job)
      else
        flash[:error] = 'User can\'t be added as collaborator'
        redirect_to job_path(@job)
      end
    end
  end

  def job_collabs_list
    @collabs_list = @job.collaborators
  end

  def remove_collab
    @rem_collab_user = User.where(:id => params[:rem_id]).first
    if @rem_collab_user.nil?
      flash[:error] = 'No user by this username found'
      redirect_to job_collabs_path(@job)
    else
      if !@job.collaborators.include?(@rem_collab_user)
        flash[:error] = 'This user is not a collaborator'
        redirect_to job_collabs_path(@job) and return
      end
      @job.collaborators.delete(@rem_collab_user)
      if !@job.collaborators.include?(@rem_collab_user)
        flash[:success] = 'User removed from collaborators successfully!'
        redirect_to job_collabs_path(@job)
      else
        flash[:error] = 'User can\'t be removed as collaborator'
        redirect_to job_collabs_path(@job)
      end
    end
  end

  private

    def set_job
      @job = Job.where(is_deleted: false).find(params[:id])
    end

    def require_same_or_collab_user
      if (!@job.collaborators.include?(current_user))&&(current_user != @job.poster)
        flash[:error] = 'You can only edit jobs you have posted'
        redirect_to jobs_path
      end
    end

    def require_same_user
      if (current_user != @job.poster)
        flash[:error] = 'You can only edit jobs you have posted'
        redirect_to jobs_path
      end
    end

    def require_same_user_from_name
      if (@name_user.nil?)||(current_user != @name_user)
        flash[:error] = 'You don\'t have permission for this action '
        redirect_to jobs_path
      end
    end

    def set_user_from_name
      @name_user = User.where(:username => params[:username]).first
    end

    def job_params
      params.require(:job).permit(:title, :company_name, :intro, :desc_nomark, :pay, :location, :req_subs)
    end
    
end