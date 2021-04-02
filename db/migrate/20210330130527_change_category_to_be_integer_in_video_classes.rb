class ChangeCategoryToBeIntegerInVideoClasses < ActiveRecord::Migration[6.1]
  def change
    change_column :video_classes, :category, :integer
  end
end
