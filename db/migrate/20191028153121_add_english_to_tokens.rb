class AddEnglishToTokens < ActiveRecord::Migration[5.2]
  def change
    add_column :tokens, :english, :string
  end
end
