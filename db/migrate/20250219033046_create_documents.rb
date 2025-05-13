class CreateDocuments < ActiveRecord::Migration[8.0]
  def change
    create_table :documents do |t|
      t.text :content
      t.integer :version, default: 1
      t.timestamps
    end
  end
end
