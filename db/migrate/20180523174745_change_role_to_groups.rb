class ChangeRoleToGroups < ActiveRecord::Migration[5.1]
  def change
    rename_column :users, :role, :group
  end
end
