class AddSizeToResources < ActiveRecord::Migration[5.1]
  def change
    add_column :resources, :size, :integer
  end
end
