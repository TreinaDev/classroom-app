class WatchedClass < ApplicationRecord
  belongs_to :customer
  belongs_to :video_class

  scope :distinct_by_video_class, -> { select('DISTINCT video_class_id') }
  scope :created_between, ->(range_date) { where(created_at: range_date) }
end
