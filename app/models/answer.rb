class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user

  validates :body, presence: true

  scope :best, -> { order 'best desc' }
  scope :created, -> { order 'created_at asc' }

  def set_best
    question.answers.update_all(best: false)
    update(best: true)
  end
end
