class RemoveUserFromVideoClass < ActiveRecord::Migration[6.1]
  def change
    remove_column :video_classes, :user, :string
  end
end
