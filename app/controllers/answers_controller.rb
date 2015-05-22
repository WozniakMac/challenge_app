class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_question, only: [:create]

  def create
    @answer = Answer.new(answer_params)
    @answer.user = current_user
    @answer.question = @question

    if @answer.save
      redirect_to question_path(@question), notice: "Answer was successfully created."
    else
      redirect_to question_path(@question), alert: "There was an error when adding answer."
    end
  end

  def like
    @answer = Answer.find(params[:answer][:answer_id])
    @question = Question.find(params[:answer][:question_id])
    if(!@answer.likes.where(user_id: current_user.id).any?)
      @like = Like.new
      @like.user = current_user
      @like.answer = @answer

      if @like.save
        redirect_to question_path(@question), notice: 'You like it!! :)'
      else
        redirect_to question_path(@question), alert: 'Samething goes wrong :/'
      end
    else
      @likes = @answer.likes.where(user_id: current_user.id)
      @likes.each do |like|
        like.destroy
      end
      redirect_to question_path(@question), notice: 'You  dont like it!! :('
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
end
