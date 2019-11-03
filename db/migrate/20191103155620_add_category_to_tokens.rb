class AddCategoryToTokens < ActiveRecord::Migration[5.2]
  def change
    add_column :tokens, :category, :string
  end
end
