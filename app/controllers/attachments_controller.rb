class AttachmentsController < ApplicationController
  respond_to :js

  def destroy
    if current_user.author_of?(attachment.attachable)
      attachment.destroy
    else
      flash.now[:alert] = 'У Вас нет прав для данной операции'
    end
    respond_with attachment
  end

  private

  def attachment
    @attachment ||= Attachment.find(params[:id])
  end
end
