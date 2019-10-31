class CreateTokenOrders < ActiveRecord::Migration[5.2]
  def change
    create_table :token_orders do |t|
      t.string :name
      t.float :weight

      t.timestamps
    end
  end
end
