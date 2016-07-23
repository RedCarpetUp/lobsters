class CollcommentsController < ApplicationController
  before_action :require_user
  before_action :set_job
  before_action :set_application
  before_action :collab_ornah, only: [:create]

  def create
    @collcomment = Collcomment.new(collcomment_params)
    @collcomment.application = @application
    @collcomment.user = current_user
    @collcomment.is_deleted = false
    @collcomment.is_auto = false
    if @collcomment.save
      flash[:success] = "Comment Posted"
      @job.collaborators.each do |touser|
        CollcommentNotify.notify(@collcomment, @application, @job, touser).deliver
      end
      redirect_to job_application_path(@job, @application)
    else
      flash[:error] = @collcomment.errors.full_messages.to_sentence.gsub('BodyNomark','Comment').gsub('Body','Comment')
      redirect_to job_application_path(@job, @application)
    end
  end

  private

    def set_job
      @job = Job.where(is_deleted: false).find(params[:job_id])
    end

    def set_application
      @application = Application.find(params[:application_id])
    end

    def collab_ornah
      if !(@job.collaborators.include?(current_user) || (@job.poster == current_user))
        flash[:danger] = 'You can only comment if you are a collaborator'
        redirect_to job_path(@job)
      end
    end

    def collcomment_params
      params.require(:collcomment).permit(:body_nomark)
    end

end