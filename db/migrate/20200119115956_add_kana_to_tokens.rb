class AddKanaToTokens < ActiveRecord::Migration[5.2]
  def change
    add_column :tokens, :kana, :string
  end
end
