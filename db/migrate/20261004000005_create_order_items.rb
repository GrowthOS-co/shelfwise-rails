class CreateOrderItems < ActiveRecord::Migration[8.1]
  def change
    create_table :order_items do |t|
      t.references :order, null: false, foreign_key: { on_delete: :cascade }
      t.references :book, null: false, foreign_key: true
      t.string :title, null: false
      t.integer :unit_price_cents, null: false
      t.integer :quantity, null: false
    end
  end
end
