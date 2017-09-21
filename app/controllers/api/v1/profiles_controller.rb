class Api::V1::ProfilesController < Api::V1::BaseController
  authorize_resource class: User

  def index
    respond_with User.list(current_resource_owner.id)
  end

  def me
    respond_with current_resource_owner
  end

  private

  def current_ability
    @current_ability ||= Ability.new(current_resource_owner)
  end
end
