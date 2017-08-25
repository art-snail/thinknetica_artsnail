class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user

  validates :body, presence: true

  scope :best_order, -> { order 'best desc' }
  scope :best, -> { where(best: true) }
  scope :created, -> { order 'created_at asc' }

  def set_best
    transaction do
      question.answers.update_all(best: false)
      update(best: true)
    end
  end
end
