class AddVideoToResources < ActiveRecord::Migration[5.1]
  def change
    add_column :resources, :video, :string
  end
end
