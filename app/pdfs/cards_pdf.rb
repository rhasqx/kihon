include ApplicationHelper

require "prawn"
require "prawn/measurement_extensions"

class CardsPdf < Prawn::Document
  
  def initialize(tokens, nx=4, ny=4, m=20)
    super(:page_size => "A4", :page_layout => :landscape, :margin => 0)

    Prawn::Font::AFM.hide_m17n_warning = true
    
    # number of boxes
    @nx = nx
    @ny = ny
    
    # page dimensions
    @pw = 297.send(:mm)
    @ph = 210.send(:mm)
    
    # box dimensions
    @bw = @pw / @nx
    @bh = @ph / @ny
    
    # margin
    @m = m
    
    parts = tokens.each_slice(@nx*@ny).to_a
    parts.each_with_index do |tokens,i|
      # definition
      font(font_path("AppliMincho.ttf")) do
        page tokens, :japanese
      end
      start_new_page
      
      # translation
      font(font_path("OpenSans-Regular.ttf")) do
        page tokens, :translation
      end
      start_new_page if i < parts.count-1
    end
  end
  
  def font_path(file="OpenSans-Regular.ttf")
    Rails.root.join("vendor", "assets", "fonts", file)
  end
  
  def grid
    stroke do
      stroke_color "cccccc"
      self.line_width 0.125
      1.upto(@ny-1).each { |i| horizontal_line 0, @pw, :at => i*@bh }
      1.upto(@nx-1).each { |i|   vertical_line 0, @ph, :at => i*@bw }
    end
  end
  
  def page(tokens,side)
    grid
    angle = side == :translation ? 180 : 0
    parts = tokens.each_slice(@nx).to_a
    parts.reverse! if side == :translation
    parts.each_with_index do |tokens,j|
      j += 1
      tokens.each_with_index do |token,i|
        x = i % @nx * @bw
        y = j * @bh
        
        options = {
          :width  => @bw - 2 * @m,
          :height => @bh - 2 * @m,
          :at     => [x + @m, y - @m],
          :rotate => angle,
          :rotate_around => :center
        }
        
        if side == :translation
          german = token.try(:german) || ""

          german = german.encode("utf-8").force_encoding("utf-8").gsub(/☐/,"#").strip

          german << "\n" unless german.empty?

          fill_color "000000"
          options.merge!({:size => 12})
          text_box german, options.merge({:align => :center, :valign => :center})
        else
          pos = token.try(:pos) || ""

          hiragana = token.try(:hiragana) || ""
          katakana = token.try(:katakana) || ""
          kanji = token.try(:kanji) || ""
          romaji = token.try(:romaji) || ""

          hiragana = hiragana.encode("utf-8").force_encoding("utf-8").gsub(/☐/,"#").strip
          katakana = katakana.encode("utf-8").force_encoding("utf-8").gsub(/☐/,"#").strip
          kanji = kanji.encode("utf-8").force_encoding("utf-8").gsub(/☐/,"#").strip
          romaji = romaji.encode("utf-8").force_encoding("utf-8").gsub(/☐/,"#").strip

          hiragana << "\n" unless hiragana.empty?
          katakana << "\n" unless katakana.empty?
          kanji << "\n" unless kanji.empty?
          romaji << "\n" unless romaji.empty?

          fill_color "000000"
          options.merge!({:size => 12})
          begin
            formatted_text_box [
                            { :text => hiragana, :size => pos == "Buchstabe" ? 48 : 18 },
                            { :text => romaji, :size => 8 },
                            { :text => katakana, :size => pos == "Buchstabe" ? 48 : 18 },
                            { :text => kanji, :size => 26 }
                        ],
                        options.merge({
                          :align => :center,
                          :valign => :center,
                          :overflow => :shrink_to_fit
                        })
          rescue
          end
        end
        
        j += 1 if (i+1) % @nx == 0
      end
    end
  end
  
end
