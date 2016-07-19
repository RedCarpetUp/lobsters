class JobsController < ApplicationController
  before_action :require_user, only: [:edit, :update, :destroy, :new, :create]
  before_action :set_job, only: [:edit, :update, :show, :destroy]
  before_action :require_same_user, only: [:edit, :update, :destroy]
  before_action :require_same_user_from_name, only: [:user_applied_jobs, :user_jobs]

  def show
    @title = @job.title
  end

  def index
    @cur_url = "/jobs"
    @title = "Jobs"
    @jobs = Job.all
  end

  def new
    @job = Job.new
    @title = "New Job"
  end

  def create
    @job = Job.new(job_params)
    @job.poster = current_user

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
    @job.destroy
    flash[:success] = 'Job Deleted'
    redirect_to jobs_path
  end

  def user_jobs
    @user_jobs = current_user.jobs
    @title = "Jobs"
  end

  def user_applied_jobs
    @user_applications = Job.where(id: current_user.applications.pluck(:job_id).uniq)
    @title = "Jobs"
  end

  private

    def set_job
      @job = Job.find(params[:id])
    end

    def require_same_user
      if current_user != @job.poster
        flash[:error] = 'You can only edit jobs you have posted'
        redirect_to job_path
      end
    end

    def require_same_user_from_name
      if current_user.username != params[:username]
        flash[:error] = 'You don\'t have permission for this action '
        redirect_to job_path
      end
    end

    def job_params
      params.require(:job).permit(:title, :company_name, :intro, :desc, :skills_reqs, :about_company, :pay, :location, :req_subs)
    end
    
end