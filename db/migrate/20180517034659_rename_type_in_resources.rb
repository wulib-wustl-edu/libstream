class RenameTypeInResources < ActiveRecord::Migration[5.1]
  def change
    rename_column :resources, :type, :content_type
  end
end
