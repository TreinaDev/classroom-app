class AddCategoryToVideoClass < ActiveRecord::Migration[6.1]
  def change
    add_column :video_classes, :category, :string
  end
end
