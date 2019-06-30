class AddNumberToTokens < ActiveRecord::Migration[5.2]
  def change
    add_column :tokens, :number, :decimal
  end
end
