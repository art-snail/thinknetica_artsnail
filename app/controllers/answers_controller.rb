class AnswersController < ApplicationController
  include Voted

  before_action :authenticate_user!
  before_action :load_answer, only: %i[update destroy set_best]
  before_action :load_question, only: [:create]

  after_action :publish_answer, only: [:create]

  respond_to :js

  authorize_resource

  def create
    @answer = @question.answers.build(answer_params)
    @answer.user = current_user
    respond_with @answer.save
  end

  def update
    respond_with @answer.update(answer_params)
  end

  def destroy
    respond_with @answer.destroy
  end

  def set_best
    @question = @answer.question
    respond_with @answer.set_best, notice: 'Ответ успешно помечен лучшим.'
  end

  private

  def publish_answer
    return if @answer.errors.any?

    ActionCable.server.broadcast(
      "question_#{@question.id}",
      @answer.to_json(include: :attachments)
    )
  end

  def load_question
    @question = Question.find(params[:question_id])
  end

  def load_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body, attachments_attributes: [:file])
  end
end
