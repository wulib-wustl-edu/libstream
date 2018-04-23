class AddFileToResources < ActiveRecord::Migration[5.1]
  def change
    add_column :resources, :file, :string
  end
end
