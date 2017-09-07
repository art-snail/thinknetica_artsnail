class CommentsController < ApplicationController
  before_action :load_commentable, only: %i[create]

  def create
    @comment = @commentable.comments.new(commentable_params)
    @comment.user = current_user
    @comment.save
  end

  private

  def load_commentable
    # binding.pry
    @commentable = commentable_name.classify.constantize.find(params[commentable_id])
  end

  def commentable_name
    params[:commentable]
  end

  def commentable_id
    (commentable_name.classify.downcase + '_id').to_sym
  end

  def commentable_params
    params.require(:comment).permit(:body)
  end
end
