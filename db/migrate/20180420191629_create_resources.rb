class CreateResources < ActiveRecord::Migration[5.1]
  def change
    create_table :resources do |t|
      t.string :item_id
      t.string :title
      t.string :subtitles
      t.string :course_id
      t.string :course_name
      t.string :semester
      t.string :instructor
      t.string :url
      t.string :type

      t.timestamps
    end
  end
end
