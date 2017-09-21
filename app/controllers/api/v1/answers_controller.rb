class Api::V1::AnswersController < Api::V1::BaseController
  authorize_resource

  before_action :load_question, only: %i[index]

  def index
    @answers = @question.answers
    respond_with @answers.order(:id)
  end

  def show
    respond_with Answer.find(params[:id])
  end

  private

  def load_question
    @question = Question.find(params[:question_id])
  end
end
