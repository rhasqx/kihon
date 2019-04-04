json.extract! token, :id, :hiragana, :katakana, :kanji, :romaji, :german, :pos, :created_at, :updated_at
json.url token_url(token, format: :json)
