class AddCategoryToVideoClasses < ActiveRecord::Migration[6.1]
  def change
    add_column :video_classes, :category, :string, null: false
  end
end
