class ChangeNumberToBeStringInTokens < ActiveRecord::Migration[5.2]
  def change
    change_column :tokens, :number, :string
  end
end
