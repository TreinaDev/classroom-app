class CreateWatchedClasses < ActiveRecord::Migration[6.1]
  def change
    create_table :watched_classes do |t|
      t.references :customer, null: false, foreign_key: true
      t.references :video_class, null: false, foreign_key: true

      t.timestamps
    end
  end
end
