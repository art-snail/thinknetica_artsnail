class Api::V1::AnswersController < Api::V1::BaseController
  authorize_resource

  before_action :load_question, only: %i[index create]

  def index
    @answers = @question.answers
    respond_with @answers.order(:id)
  end

  def show
    respond_with Answer.find(params[:id])
  end

  def create
    respond_with @answer = @question.answers.create(answer_params)
  end

  private

  def answer_params
    params.require(:answer).permit(:body).merge(user: current_resource_owner)
  end

  def load_question
    @question = Question.find(params[:question_id])
  end
end
