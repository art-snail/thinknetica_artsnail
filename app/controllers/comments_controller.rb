class CommentsController < ApplicationController
  before_action :load_commentable, only: %i[create]
  after_action :publish_comment, only: [:create]

  def create
    @comment = @commentable.comments.new(commentable_params)
    @comment.user = current_user
    @comment.save
  end

  private

  def load_commentable
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

  def publish_comment
    return if @comment.errors.any?

    id = @comment.commentable.try(:question) ? @comment.commentable.question.id : @comment.commentable.id

    ActionCable.server.broadcast(
        "comments/question_#{id}",
        @comment.to_json
    )
  end
end
