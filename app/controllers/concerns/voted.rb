module Voted
  extend ActiveSupport::Concern

  included do
    before_action :get_resource, only: %i[vote_up]
  end

  def vote_up
    if @resource.voted?(current_user) || current_user.author_of?(@resource)
      # render json: {'err':'Вы не можете голосовать'}, status: :unprocessable_entity
      render json: 'Вы не можете голосовать', status: :unprocessable_entity
    else
      @resource.vote(current_user, 1)
      render json: @resource.votes.result
    end
  end

  private

  def get_resource
    @resource = model_klass.find(params[:id])
  end

  def model_klass
    controller_name.classify.constantize
  end
end