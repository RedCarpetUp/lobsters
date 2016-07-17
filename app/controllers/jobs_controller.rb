class JobsController < ApplicationController
  before_action :require_user, only: [:edit, :update, :destroy, :new, :create]
  before_action :set_job, only: [:edit, :update, :show, :destroy]
  before_action :require_same_user, only: [:edit, :update, :destroy]
 
  def show
  end

  def index
    @cur_url = "/jobs"
    @jobs = Job.all
  end

  def new
    @job = Job.new
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

    def job_params
      params.require(:job).permit(:title, :company_name, :intro, :desc, :skills_reqs, :about_company, :pay, :location, :req_subs)
    end
    
end