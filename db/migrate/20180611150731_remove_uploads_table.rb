class RemoveUploadsTable < ActiveRecord::Migration[5.1]
  def change
    drop_table :uploads
  end
end
