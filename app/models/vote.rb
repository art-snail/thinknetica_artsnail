class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :votable, polymorphic: true

  def self.result
    sum(:option)
  end
end
