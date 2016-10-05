class ApplQuestionsController < ApplicationController
  if Rails.application.config.anon_apply == true
    before_action :require_user, except: [:show, :update]
  else
    before_action :require_user
  end
  before_action :set_job
  before_action :set_application
  before_action :set_applquestion, only: [:show, :update, :destroy]

  before_action :not_read_only, only: [:update]

  before_action :collab_ornah, only: [:new, :create, :destroy]
  if Rails.application.config.anon_apply == true
    before_action :require_poster_or_collab_or_applicant, only: [:index]
  else
    before_action :require_poster_or_collab_or_applicant, only: [:index, :show]
  end

  if Rails.application.config.anon_apply == true
    before_action :require_applicant_ornah, only: [:show]
  end

  before_action :require_not_collab, only: [:update]

  def index
    @title = "Questions"
    @applquestions = @application.appl_questions.where(:is_deleted => false)
  end

  def show
    @title = "Answer Question"
  end

  def update
    if @applquestion.update(applquestion_answer_params)
      flash[:success] = 'Answered Successfully!'
      @job.collaborators.each do |touser|
        if Rails.application.config.side_mail == true
          QuestionAnsweredNotify.delay.notify(@applquestion, @application, touser)
        else
          QuestionAnsweredNotify.notify(@applquestion, @application, touser).deliver
        end
      end
      if Rails.application.config.side_mail == true
        QuestionAnsweredNotify.delay.notify(@applquestion, @application, @job.poster)
      else
        QuestionAnsweredNotify.notify(@applquestion, @application, @job.poster).deliver
      end
      redirect_to job_application_appl_question_path(@job, @application, @applquestion)
    else
      render :show
    end
  end

  def new
    @title = "New Question"
    @applquestion = ApplQuestion.new
  end

  def create
    @applquestion = ApplQuestion.new(applquestion_ask_params)
    @applquestion.application = @application
    @applquestion.asker = current_user
    @applquestion.is_deleted = false
    if @applquestion.save
      flash[:success] = "Question Posted"
      @job.collaborators.each do |touser|
        if Rails.application.config.side_mail == true
          QuestionAskedNotify.delay.notify(@applquestion, @application, touser)
        else
          QuestionAskedNotify.notify(@applquestion, @application, touser).deliver
        end
      end
      if Rails.application.config.side_mail == true
        QuestionAskedNotify.delay.notify(@applquestion, @application, @job.poster)
      else
        QuestionAskedNotify.notify(@applquestion, @application, @job.poster).deliver
      end
      if Rails.application.config.side_mail == true
        QuestionSentNotify.delay.notify(@applquestion, @application)
      else
        QuestionSentNotify.notify(@applquestion, @application).deliver
      end
      redirect_to job_application_path(@job, @application)
    else
      flash[:error] = @applquestion.errors.full_messages.to_sentence
      redirect_to new_job_application_appl_question_path(@job, @application)
    end
  end

  def destroy
    @applquestion.is_deleted = true
    @applquestion.save
    flash[:success] = 'Question Deleted'
    redirect_to job_application_appl_questions_path(@job, @application)
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

    def set_applquestion
      @applquestion = @application.appl_questions.where(:is_deleted => false).find(params[:id])
    end

    def collab_ornah
      if user_signed_in?
        if !(@job.collaborators.include?(current_user) || (@job.poster == current_user))
          flash[:danger] = 'You can only create/delete question if you are a collaborator'
          redirect_to job_path(@job)
        end
      else
        flash[:danger] = 'You can only create/delete question if you are a collaborator'
        redirect_to job_path(@job)
      end
    end

    def require_poster_or_collab_or_applicant
      if Rails.application.config.anon_apply == true
        if user_signed_in?
          if (current_user != @job.poster) and (!@job.collaborators.include?(current_user))
            if @application.applicant_id.nil?
              flash[:error] = 'You are not allowed to do this action'
              redirect_to job_path(@job)      
            else
              if @application.applicant != current_user
                flash[:error] = 'You are not allowed to do this action'
                redirect_to job_path(@job)
              end
            end
          end
        else
          flash[:error] = 'You are not allowed to do this action'
          redirect_to job_path(@job)
        end
      else
        if user_signed_in?
          if (current_user != @job.poster) and (current_user != @application.applicant) and (!@job.collaborators.include?(current_user))
              flash[:error] = 'You are not allowed to do this action'
              redirect_to job_path(@job)
          end
        else
          flash[:error] = 'You are not allowed to do this action'
          redirect_to job_path(@job)
        end
      end
    end

    def require_not_collab
      if Rails.application.config.anon_apply == true
        if user_signed_in?
          if (@job.collaborators.include?(current_user))||(current_user == @job.poster)
              flash[:error] = 'You are not allowed to apply to your own job'
              redirect_to job_path(@job)
          end 
        else
          if !@applquestion.application.applicant_id.nil?
            flash[:error] = 'You are not allowed to view this'
            redirect_to job_path(@job)
          end
        end
      else
        if user_signed_in?
          if (@job.collaborators.include?(current_user))||(current_user == @job.poster)
              flash[:error] = 'You are not allowed to apply to your own job'
              redirect_to job_path(@job)
          end
        else
          flash[:error] = 'You are not allowed to apply to your own job'
          redirect_to job_path(@job)
        end
      end
    end

    def require_applicant_ornah
      if !@application.applicant_id.nil?
        if ((!user_signed_in?)||(current_user != @application.applicant))
            flash[:error] = 'You are not allowed to view this'
            redirect_to job_path(@job)
        end
      end
    end

    def applquestion_ask_params
      params.require(:appl_question).permit(:question)
    end

    def applquestion_answer_params
      params.require(:appl_question).permit(:answer_nomark)
    end

    def not_read_only
      if @job.is_closed == true
        flash[:error] = 'This job is archived hence can\'t be modified'
        redirect_to job_path(@job)
      end
    end

end