class CreateVideoClasses < ActiveRecord::Migration[6.1]
  def change
    create_table :video_classes do |t|
      t.string :name
      t.text :description
      t.string :video_url
      t.string :user
      t.datetime :start_at
      t.datetime :end_at

      t.timestamps
    end
  end
end
