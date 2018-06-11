class FixResourceGroupName < ActiveRecord::Migration[5.1]
  def change
    rename_column :resources, :group, :content_group
  end
end
