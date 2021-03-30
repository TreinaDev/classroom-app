class VideoClass < ApplicationRecord
  belongs_to :user

  has_many :watched_classes
  has_many :customers, through: :watched_classes

  validates :name, :description, :start_at, :end_at,
            :video_url, :category, presence: true
  validate :end_date_cannot_be_before_start_date

  private

  def end_date_cannot_be_before_start_date
    return unless (end_at.present? && start_at.present?) && (end_at < start_at)

    errors.add(:end_at, 'não pode ser anterior a horário de início!')
  end
end
