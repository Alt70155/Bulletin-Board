class CreateComments < ActiveRecord::Migration[5.2]
  def change
    create_table :comments do |t|
      t.string :name
      t.text :body, null: false
      t.string :reply_path
      t.references :topic, foreign_key: true

      t.timestamps
    end
    add_index :comments, [:topic_id, :created_at]
  end
end
