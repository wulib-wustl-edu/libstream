class AddLimitToResources < ActiveRecord::Migration[5.1]
  def change
    change_column :resources, :size, :integer, limit: 8
  end
end
