class AttachmentsController < ApplicationController
  def destroy
    # binding.pry
    if current_user.author_of?(load_attachment.attachable)
      load_attachment.destroy
      flash.now[:notice] = 'Фаил удалён'
    else
      flash.now[:alert] = 'У Вас нет прав для данной операции'
    end
  end

  private

  def load_attachment
    @attachment = Attachment.find(params[:id])
  end
end
