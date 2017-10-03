class SearchController < ApplicationController
  include SearchHelper

  skip_authorization_check

  def index
    respond_with search(params[:object], params[:text])
  end
end
