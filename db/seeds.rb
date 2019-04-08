# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'csv'

file = 'japanisch-a1-1.csv'
headers = %w(created_at hiragana katakana kanji romaji german pos updated_at)

csv_text = File.read(Rails.root.join('lib', 'seeds', file))
csv_text = headers.join(";")+"\r\n" + csv_text.gsub(/\A(.*\n){1}/,'')

csv = CSV.parse(csv_text, :headers => true, :encoding => 'UTF-8', col_sep: ';')
csv.each do |row|
    row = row.to_hash

    begin
        row['created_at'] = Date.parse(row['created_at'])
    rescue
        row['created_at'] = Date.current
    end

    begin
        row['updated_at'] = Date.parse(row['updated_at'])
    rescue
        row['updated_at'] = row['created_at']
    end

    temp = row
    if temp.reject{|k,v| k == "created_at" || k == "updated_at" || v.nil?}.values.size > 0
        token = Token.create(row)
    end
end

puts "There are now #{Token.count} rows in the tokens table."
