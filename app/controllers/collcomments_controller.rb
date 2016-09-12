class CollcommentsController < ApplicationController
  before_action :require_user
  before_action :set_job
  before_action :set_application
  before_action :collab_ornah, only: [:create]
  before_action :not_read_only, only: [:create]

  def create
    @collcomment = Collcomment.new(collcomment_params)
    @collcomment.application = @application
    @collcomment.user = current_user
    @collcomment.is_deleted = false
    @collcomment.is_auto = false
    if @collcomment.save
      flash[:success] = "Comment Posted"
      @job.collaborators.each do |touser|
        CollcommentNotify.delay.notify(@collcomment, @application, @job, touser)
      end
      CollcommentNotify.delay.notify(@collcomment, @application, @job, @job.poster)
      redirect_to job_application_path(@job, @application)
    else
      flash[:error] = @collcomment.errors.full_messages.to_sentence
      redirect_to job_application_path(@job, @application)
    end
  end

  private

    def set_job
      @jobx =  Job.where(:is_deleted => false).find(params[:job_id])
      if user_signed_in?
        if @jobx.collaborators.include?(current_user)||(current_user == @jobx.poster)
          @job = @jobx
        else
          @job = Job.where(:is_deleted => false).where(is_closed: false).find(params[:job_id])
        end
      else
        @job = Job.where(:is_deleted => false).where(is_closed: false).find(params[:job_id])
      end
    end

    def set_application
      @application = @job.applications.where(is_deleted: false).find(params[:application_id])
    end

    def collab_ornah
      if user_signed_in?
        if !(@job.collaborators.include?(current_user) || (@job.poster == current_user))
          flash[:danger] = 'You can only comment if you are a collaborator'
          redirect_to job_path(@job)
        end
      else
        flash[:danger] = 'You can only comment if you are a collaborator'
        redirect_to job_path(@job)
      end
    end

    def collcomment_params
      params.require(:collcomment).permit(:body_nomark)
    end

    def not_read_only
      if @job.is_closed == true
        flash[:error] = 'This job is archived hence can\'t be modified'
        redirect_to job_path(@job)
      end
    end

end