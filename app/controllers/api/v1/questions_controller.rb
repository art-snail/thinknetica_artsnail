class Api::V1::QuestionsController < Api::V1::BaseController
  authorize_resource

  def index
    @questions = Question.all
    respond_with @questions
  end

  def show
    respond_with Question.find(params[:id])
  end
end