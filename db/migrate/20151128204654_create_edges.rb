class CreateEdges < ActiveRecord::Migration
  def change
    create_table :edges do |t|
      t.float      :distance
      t.integer    :time
      t.references :node1, index: true, references: :nodes
      t.references :node2, index: true, references: :nodes

      t.timestamps null: false
    end
  end
end
