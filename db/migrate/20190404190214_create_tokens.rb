class CreateTokens < ActiveRecord::Migration[5.2]
  def change
    create_table :tokens do |t|
      t.text :hiragana
      t.text :katakana
      t.text :kanji
      t.text :romaji
      t.text :german
      t.text :pos

      t.timestamps
    end
  end
end
