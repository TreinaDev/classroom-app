class VideoClass < ApplicationRecord
  belongs_to :user

  validates :name, :description, :start_at, :end_at, :video_url, presence: true
  validate :end_date_after_start_date?

  private

  def end_date_after_start_date?
    if !end_at.nil? && !start_at.nil?
      errors.add(:end_at, 'não pode ser anterior a data de início!') if end_at < start_at
    end
  end
end
