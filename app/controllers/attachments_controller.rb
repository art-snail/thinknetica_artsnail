class AttachmentsController < ApplicationController
  respond_to :js

  before_action :load_attachment, only: :destroy

  authorize_resource

  def destroy
    respond_with @attachment.destroy
  end

  private

  def load_attachment
    @attachment = Attachment.find(params[:id])
  end
end
