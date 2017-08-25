class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_answer, only: %i[update destroy set_best]
  before_action :load_question, only: [:create]

  def create
    @answer = @question.answers.build(answer_params)
    @answer.user = current_user
    @answer.save
  end

  def update
    @answer.update(answer_params)
  end

  def destroy
    if current_user.author_of?(@answer)
      @answer.destroy
      flash[:notice] = 'Ответ успешно удалён.'
    else
      flash[:alert] = 'У Вас нет прав для данной операции'
    end
  end

  def set_best
    # binding.pry
    if current_user.author_of?(@answer.question)
      @answer.set_best
      flash[:notice] = 'Ответ успешно помечен лучшим'
    else
      flash[:alert] = 'У Вас нет прав для данной операции'
    end
  end

  private

  def load_question
    @question = Question.find(params[:question_id])
  end

  def load_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
