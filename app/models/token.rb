class Token < ApplicationRecord
    
    paginates_per 20

    def readonly?
        File.exists?(Rails.root.join('readonly'))
    end
  
    def self.search(search)
      if search
        where("lower(german) LIKE :search or lower(romaji) LIKE :search or lower(kanji) LIKE :search or lower(hiragana) LIKE :search or lower(katakana) LIKE :search", search: "%#{search.downcase}%")
      else
        all
      end
    end
    
end
