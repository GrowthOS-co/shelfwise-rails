class CreateBooks < ActiveRecord::Migration[8.1]
  def change
    create_table :books do |t|
      t.string :title, null: false
      t.string :author, null: false
      t.string :isbn, null: false, index: { unique: true }
      t.string :genre, null: false
      t.integer :published_year, null: false
      t.text :description, null: false
      t.integer :price_cents, null: false
      t.integer :stock, null: false
    end
  end
end
