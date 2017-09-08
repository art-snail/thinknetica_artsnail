class CommentsChannel < ApplicationCable::Channel
  def follow
    stream_from "comments/question_#{params[:id]}"
  end
end
