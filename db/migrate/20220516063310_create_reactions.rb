class CreateReactions < ActiveRecord::Migration[6.0]
  def change
    create_table :reactions do |t|
      t.references :to_user, null: false, foreign_key: { to_table: :users }
      t.references :from_user, null: false, foreign_key: { to_table: :users }
      t.integer :status, null: false

      t.timestamps
    end
    add_index :reactions, %i[to_user_id from_user_id], unique: true
  end
end
