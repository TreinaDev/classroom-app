class AddStatusToVideoClass < ActiveRecord::Migration[6.1]
  def change
    add_column :video_classes, :status, :integer, default: 0, null: false
  end
end
