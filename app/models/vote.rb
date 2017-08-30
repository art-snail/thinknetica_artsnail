class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :votable, polymorphic: true

  def self.result
    self.sum(:option)
  end
end
