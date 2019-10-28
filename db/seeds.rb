# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require "csv"
require "progress_bar"

#######################################

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
    row["pos"] ||= ""
    row["english"] ||= ""
    row["german"] ||= ""

    row["hiragana"] = row["kana"] if row["kana"].contains_hiragana?
    row["katakana"] = row["kana"] if row["kana"].contains_katakana?
    row["romaji"] = [row["hiragana"], row["katakana"], row["kana"], row["kanji"], ""].reject(&:empty?).first.romaji.gsub(/,/,", ")

    temp = row
    if temp.reject{|k,v| k == "created_at" || k == "updated_at" || v.nil?}.values.size > 0
        row.delete "level"
        row.delete "kana"
        token = Token.create(row)
    end

    bar.increment!
end

#######################################

file = "nihonngo.csv"
csv_text = File.read(Rails.root.join("lib", "seeds", file))
csv = CSV.parse(csv_text, :headers => true, :encoding => "UTF-8", col_sep: ";")
bar = ProgressBar.new(csv.size, :percentage, :counter, :bar)
csv.each do |row|
    row = row.to_hash
    
    row["kanji"] ||= ""
    row["hiragana"] ||= ""
    row["katakana"] ||= ""
    row["pos"] ||= ""
    row["english"] ||= ""
    row["german"] ||= ""

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

    row["romaji"] = [row["hiragana"], row["katakana"], row["kanji"], ""].reject(&:empty?).first.romaji.gsub(/,/,", ")

    temp = row
    if temp.reject{|k,v| k == "created_at" || k == "updated_at" || v.nil?}.values.size > 0
        row.delete "key"
        token = Token.create(row)
    end

    bar.increment!
end

#######################################

puts "There are now #{Token.count} rows in the tokens table."
