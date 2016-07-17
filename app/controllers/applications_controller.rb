class ApplicationsController < ApplicationController
  before_action :require_user
  before_action :set_job
  before_action :set_application, only: [:edit, :update, :show, :destroy, :change_status]
  before_action :require_same_user, only: [:edit, :update, :destroy]
  before_action :require_poster, only: [:change_status]
  before_action :require_poster_or_applicant, only: [:show, :index]
  before_action :require_not_poster, only: [:new, :create]
 
  def change_status
  	out_to_flash = @application.mod_status(params[:status])
  	if out_to_flash.result == "success"
      flash[:success] = out_to_flash.statement
      redirect_to jobs_applications_path(@job)
  	else
      flash[:error] = out_to_flash.statement
      redirect_to jobs_applications_path(@job)
  	end
  end

  def show
  end

  def index
    @applications = @job.applications
  end

  def new
    @application = Application.new
    @application.name = current_user.username
    @application.email = current_user.email
  end

  def create
    @application = Application.new(application_params)
    @application.applicant = current_user
    @application.job = Job.find(params[:job_id])

    if @application.save
      flash[:success] = "Application Created!"
      redirect_to job_application_path(@application)
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @application.update(application_params)
      flash[:success] = 'Updated Successfully!'
      redirect_to job_application_path(@application)
    else
      render :edit
    end
  end

  def destroy
    tempjob = @application.job
    @application.destroy
    flash[:success] = 'Application Deleted'
    redirect_to job_path(tempjob)
  end

  private

    def set_application
      @application = Application.find(params[:id])
    end

    def set_job
      @job = Job.find(params[:job_id])
    end

    def require_same_user
      if current_user != @application.applicant
        flash[:error] = 'You can only edit applications you have posted'
        redirect_to job_application_path
      end
    end

    def require_poster
    	if current_user != @job.poster
        	flash[:error] = 'You are not allowed to do this action'
        	redirect_to job_path(@job)
    	end
    end

    def require_poster_or_applicant
    	if (current_user != @job.poster) and (current_user != @application.applicant)
        	flash[:error] = 'You are not allowed to see applications'
        	redirect_to job_path(@job)
    	end 
    end

    def require_not_poster
      if current_user == @job.poster
          flash[:error] = 'You are not allowed to apply to your own job'
          redirect_to job_path(@job)
      end 
    end

    def application_params
      params.require(:application).permit(:name, :email, :phoneno, :details, :status)
    end
    
end