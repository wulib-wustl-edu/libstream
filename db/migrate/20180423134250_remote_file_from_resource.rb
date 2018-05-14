class RemoteFileFromResource < ActiveRecord::Migration[5.1]
  def change
    remove_column :resources, :file, :string
  end
end
