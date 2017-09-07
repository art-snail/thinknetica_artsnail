module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, dependent: :destroy
  end

  def voted?(user)
    votes.where(user: user).exists?
  end

  def vote(user, option)
    transaction do
      votes.where(user: user).destroy_all
      votes.create!(user: user, option: option)
    end
  end
end
