class RemoveUrlFromResources < ActiveRecord::Migration[5.1]
  def change
    remove_column :resources, :url
  end
end
