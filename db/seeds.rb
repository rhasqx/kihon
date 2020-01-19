# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require "csv"
require "progress_bar"
require "action_view"

#######################################

tokenorders = %w(文字 名 連 形 形動 動 動I 動II 動III 副 代 連体 接 感 助動 助 頭 尾 数 文 nil)
tokenorders.each_with_index do |name, index|
    TokenOrder.create(name: name, weight: index)
end

#######################################

=begin
file = "JLPT-N5.csv"
csv_text = File.read(Rails.root.join("lib", "seeds", file))
csv = CSV.parse(csv_text, :headers => true, :encoding => "UTF-8", col_sep: ";", liberal_parsing: true)
bar = ProgressBar.new(csv.size, :percentage, :counter, :bar)
csv.each do |row|
    row = row.to_hash

    row["created_at"] = Date.current
    row["updated_at"] = row["created_at"]
    row["course"] = "JLPT"
    row["number"] = row["level"]
    
    row["kana"] ||= ""
    row["kanji"] ||= ""
    row["hiragana"] ||= ""
    row["katakana"] ||= ""
    row["romaji"] ||= ""
    row["english"] ||= ""
    row["german"] ||= ""
    row["pos"] ||= ""

    row["hiragana"] = row["kana"] if row["kana"].contains_hiragana?
    row["katakana"] = row["kana"] if row["kana"].contains_katakana?
    row["romaji"] = [row["hiragana"], row["katakana"], row["kana"], row["kanji"], ""].reject(&:empty?).first.romaji.gsub(/,/,", ")

    temp = row
    if temp.reject{|k,v| k == "created_at" || k == "updated_at" || v.nil?}.values.size > 0
        row.delete "level"
        row.delete "kana"
        row["pos"] = "nil" if row["pos"].empty?
        token = Token.create(row)
    end

    bar.increment!
end
=end

#######################################

file = "JLPT-N5-groups.csv"
csv_text = File.read(Rails.root.join("lib", "seeds", file))
csv = CSV.parse(csv_text, :headers => true, :encoding => "UTF-8", col_sep: ";", liberal_parsing: true)
bar = ProgressBar.new(csv.size, :percentage, :counter, :bar)
csv.each do |row|
    row = row.to_hash

    row["created_at"] = Date.current
    row["updated_at"] = row["created_at"]
    row["course"] = "JLPT"
    row["number"] = row["level"]
    
    row["kana"] ||= ""
    row["kanji"] ||= ""
    row["hiragana"] ||= ""
    row["katakana"] ||= ""
    row["romaji"] ||= ""
    row["english"] ||= ""
    row["german"] ||= ""
    row["pos"] ||= ""
    row["category"] ||= ""

    row["category"] = row["category"] unless row["category"].nil?
    row["hiragana"] = row["kana"] if row["kana"].contains_hiragana?
    row["katakana"] = row["kana"] if row["kana"].contains_katakana?
    row["romaji"] = [row["hiragana"], row["katakana"], row["kana"], row["kanji"], ""].reject(&:empty?).first.romaji.gsub(/,/,", ")

    temp = row
    if temp.reject{|k,v| k == "created_at" || k == "updated_at" || v.nil?}.values.size > 0
        row.delete "level"
        row.delete "kana"
        row["pos"] = "nil" if row["pos"].empty?
        token = Token.create(row)
    end

    bar.increment!
end

#######################################

file = "vhs-heilbronn.csv"
csv_text = File.read(Rails.root.join("lib", "seeds", file))
csv = CSV.parse(csv_text, :headers => true, :encoding => "UTF-8", col_sep: ";")
bar = ProgressBar.new(csv.size, :percentage, :counter, :bar)
csv.each do |row|
    row = row.to_hash
    
    row["kana"] ||= ""
    row["kanji"] ||= ""
    row["hiragana"] ||= ""
    row["katakana"] ||= ""
    row["english"] ||= ""
    row["german"] ||= ""
    row["pos"] ||= ""

    begin
        row["created_at"] = Date.parse(row["created_at"])
    rescue
        row["created_at"] = Date.current
    end

    begin
        row["updated_at"] = Date.parse(row["updated_at"])
    rescue
        row["updated_at"] = row["created_at"]
    end

    row["romaji"] = [row["kana"], row["kanji"], row["hiragana"], row["katakana"], ""].reject(&:empty?).map{|x|x.gsub(/<rb>.*?<\/rb>/,"")}.map{|x|x.gsub(/<.*?>/,"")}.first.romaji.gsub(/,/,", ")


    temp = row
    if temp.reject{|k,v| k == "created_at" || k == "updated_at" || v.nil?}.values.size > 0
        row.delete "key"
        row["pos"] = "nil" if row["pos"].empty?
        token = Token.create(row)
    end

    bar.increment!
end

#######################################

puts "There are now #{Token.count} rows in the tokens table."

#######################################

# translation -> todo!
=begin
Token.all.each_with_index do |token, i|
    if token["german"].empty?
        cmd = "trans -s en -t de -b \"#{token["english"]}\""
        translation = `#{cmd} 2>/dev/null`.strip
        token["german"] = translation
        token.save
        print "[#{i}] ", token["english"], " -> ", translation, "\n"
    end
end
=end