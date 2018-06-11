class AddGroupToResources < ActiveRecord::Migration[5.1]
  def change
    add_column :resources, :group, :string
  end
end
