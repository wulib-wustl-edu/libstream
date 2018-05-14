class RenameFilesToVideo < ActiveRecord::Migration[5.1]
  def change
    rename_column :resources, :files, :video
  end
end
