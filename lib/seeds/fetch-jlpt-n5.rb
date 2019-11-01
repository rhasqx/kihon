#!/usr/bin/env ruby

=begin
    fetch-jlpt-n5 is part of https://github.com/rhasqx/kihon

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
=end

# Usage: ruby fetch-jlpt-n5.rb > JLPT-N5.csv
# Vocabulary source: https://en.wikibooks.org/wiki/JLPT_Guide

require "nokogiri"
require "open-uri"
require "mojinizer"

levels = (1..5).to_a.reverse.map{|x|"N#{x}"}
rows = %w(A Ka Sa Ta Na Ha Ma Ya Ra Wa)

def wikibooks_url(level, row)
    "https://en.wikibooks.org/wiki/JLPT_Guide/JLPT_#{level}_Vocabulary/Row_#{row}"
end

level = levels.first
urls = rows.map{|row|wikibooks_url(level, row)}

jp = ["名", "代", "動I", "動II", "動III", "形", "形動", "副", "連体", "接", "感", "助動", "助", "頭", "尾", "連"]
en = ["noun", "pronoun", "Type I verb", "Type II verb", "Type III verb", "adjective", "adjectival noun", "adverb", "attribute", "conjunction", "interjection", "auxiliary", "particle", "prefix", "suffix", "compound"]
pos = [jp, en].transpose.to_h

puts "\""+%w(number kana kanji pos english hiragana katakana level).join("\";\"")+"\""
urls.each do |url|
    doc = Nokogiri::HTML(open(url))
    doc.css("table").each do |table|
        headers = table.css("tr th").map{|th|th.content.strip}
        next unless headers.join(",") == "#,Kana,Kanji,Word type,Meaning"
        table.css("tr").each do |tr|
            columns = tr.css("td").map{|td|td.content.strip}
            next unless columns.size == 5
            columns = [%w(number kana kanji pos english), columns].transpose.to_h
            
            columns["number"] = columns["number"].strip.to_i
            columns["kana"] = columns["kana"].strip
            columns["kanji"] = columns["kanji"].gsub(/[【】]/,"").strip
            columns["pos"] = columns["pos"].gsub(/[()]/,"").strip
            columns["english"] = columns["english"].gsub(/\"/, "'").gsub(/\//, " / ").strip

            columns["hiragana"] = ""
            columns["hiragana"] = columns["kana"] if columns["kana"].hiragana?

            columns["katakana"] = ""
            columns["katakana"] = columns["kana"] if columns["kana"].katakana?

            columns["level"] = level

            puts "\""+columns.values.join("\";\"")+"\""
        end
    end
end
