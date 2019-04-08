class Token < ApplicationRecord
    
    paginates_per 20

    after_create :tts
    after_update :tts

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
    
    def tts
      aiff = "/tmp/tts.aiff"
      %w(hiragana katakana kanji).each do |component|
        mp3 = Rails.root.join("public", "assets", "tts", component, "#{self.id}.mp3")
        if !File.file?(mp3)
          text = self.send(component) || ""
          if !text.empty?
              cmd = "say -v Kyoko \"#{text}\" -o \"#{aiff}\" && ffmpeg -i \"#{aiff}\" -y -f mp3 -acodec libmp3lame -ab 192000 -ar 44100 \"#{mp3}\""
              status = `#{cmd}`
          end
        end
      end
    end
end
