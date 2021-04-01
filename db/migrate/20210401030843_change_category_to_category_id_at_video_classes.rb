class ChangeCategoryToCategoryIdAtVideoClasses < ActiveRecord::Migration[6.1]
  def change
    rename_column :video_classes, :category, :category_id
  end
end
