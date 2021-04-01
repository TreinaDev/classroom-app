class VideoClass < ApplicationRecord
  belongs_to :user

  has_many :watched_classes, dependent: :restrict_with_exception
  has_many :customers, through: :watched_classes

  validates :name, :description, :start_at, :end_at,
            :video_url, :category_id, presence: true
  validate :end_date_cannot_be_before_start_date

  def category
    @category ||= Category.all.find { |cat| cat.id == category_id }
  end

  private

  def end_date_cannot_be_before_start_date
    return unless (end_at.present? && start_at.present?) && (end_at < start_at)

    errors.add(:end_at, 'não pode ser anterior a horário de início!')
  end
end
