class AddGroupToTokens < ActiveRecord::Migration[5.2]
  def change
    add_column :tokens, :gorup, :string
  end
end
