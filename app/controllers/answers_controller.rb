class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_question, only: [:create]
  before_action :set_accept_params, only: [:accept]
  before_action :chech_author, only: [:accept]


  def create
    @answer = Answer.new(answer_params)
    @answer.user = current_user
    @answer.question = @question
    if @answer.question.answers.where(accepted: true).any?
      redirect_to @question, alert: 'This question is accepted!'
    else

      if @answer.save
        NewAnswerJob.set(wait: 20.seconds).perform_later(@question.user,@question)
        redirect_to question_path(@question), notice: "Answer was successfully created."
      else
        redirect_to question_path(@question), alert: "There was an error when adding answer."
      end
    end
  end

  def like
    @answer = Answer.find(params[:answer][:answer_id])
    @question = @answer.question
    if(!@answer.likes.where(user_id: current_user.id).any?)
      @like = Like.new
      @like.user = current_user
      @like.answer = @answer
      user = @answer.user
      if @like.save
        user.add_points(5)
        respond_to do |format|
          format.html { redirect_to question_path(@question), notice: 'You like it!! :)' }
          format.js
        end
      else
        redirect_to question_path(@question), alert: 'Samething goes wrong :/'
      end
    else
      @likes = @answer.likes.where(user_id: current_user.id)
      @likes.each do |like|
        like.destroy
        like.save
      end
      user = @answer.user
      user.remove_points(5)
      respond_to do |format|
        format.html { redirect_to question_path(@question), notice: 'You  dont like it!! :(' }
        format.js
      end
    end
  end

  def accept
    if @answer.accepted == true
      @answer.accepted = false
      @answer.save
      user = @answer.user
      user.remove_points(25)
      redirect_to @question, notice: 'The Chosen One is not exist anymore'
    elsif(!@question.answers.where(accepted: true).any?)
      @answer.accepted = true
      @answer.save
      user = @answer.user
      user.add_points(25)
      AnswerAcceptedJob.set(wait: 20.seconds).perform_later(user,@question)
      redirect_to @question, notice: 'The Chosen One was chosen!!'
    end
  end

  private

    def set_question
      @question = Question.find(params[:question_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def answer_params
      params.require(:answer).permit(:contents)
    end

    def set_accept_params
      @answer = Answer.find(params[:answer][:answer_id])
      @question = @answer.question
    end

    def chech_author
      unless current_user == @question.user
        redirect_to @question, alert: 'You are not an author!'
      end 
    end

end
