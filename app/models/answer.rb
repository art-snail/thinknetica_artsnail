class Answer < ApplicationRecord
  include Votable

  belongs_to :question
  belongs_to :user

  has_many :attachments, as: :attachable, dependent: :destroy
  has_many :comments, as: :commentable, dependent: :destroy

  validates :body, presence: true

  accepts_nested_attributes_for :attachments, reject_if: :all_blank, allow_destroy: true

  scope :best_order, -> { order 'best desc' }
  scope :best, -> { where(best: true) }
  scope :created, -> { order 'created_at asc' }

  def set_best
    transaction do
      question.answers.update_all(best: false)
      update!(best: true)
    end
  end
end
