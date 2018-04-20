class AddHashIdToResources < ActiveRecord::Migration[5.1]
  def change
    add_column :resources, :hashid, :string
    add_index :resources, :hashid, unique: true
  end
end
