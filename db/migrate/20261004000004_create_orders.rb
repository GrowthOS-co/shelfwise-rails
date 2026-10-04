class CreateOrders < ActiveRecord::Migration[8.1]
  def change
    create_table :orders do |t|
      t.string :number, null: false, index: { unique: true }
      t.string :customer_name, null: false
      t.string :email, null: false
      t.text :shipping_address, null: false
      t.string :status, null: false, default: "placed"
      t.datetime :created_at, null: false, default: -> { "CURRENT_TIMESTAMP" }
      t.datetime :shipped_at
    end
  end
end
