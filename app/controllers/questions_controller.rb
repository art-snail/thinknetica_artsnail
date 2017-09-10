class QuestionsController < ApplicationController
  include Voted

  before_action :authenticate_user!, except: %i[index show]
  before_action :load_question, only: %i[show edit update destroy]
  before_action :build_answer, only: :show

  after_action :publish_question, only: %i[create]

  respond_to :js

  def index
    respond_with(@questions = Question.all)
  end

  def show
    gon.question = @question

    respond_with @question
  end

  def new
    respond_with @question = Question.new
  end

  def edit; end

  def create
    respond_with(@question = current_user.questions.create(question_params))
  end

  def update
    respond_with @question.update(question_params)
  end

  def destroy
    if current_user.author_of?(@question)
      @question.destroy
    else
      flash[:alert] = 'У Вас нет прав для данной операции'
    end
    respond_with @question
  end

  private

  def flash_interpolation_options
    { resource_name: 'Your question' }
  end

  def build_answer
    @answer = @question.answers.build
  end

  def publish_question
    return if @question.errors.any?
    ActionCable.server.broadcast(
        'questions',
        ApplicationController.render(
          partial: 'questions/question',
          locals: { question: @question }
        )
    )
  end

  def question_params
    params.require(:question).permit(:title, :body, attachments_attributes: %i[id file _destroy])
  end

  def load_question
    @question ||= Question.find(params[:id])
  end
end
