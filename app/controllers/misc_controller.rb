class MiscController < ApplicationController
  def print
    @vowels = %w(a i u e o ya yu yo).to_a
  
    @letters = [@vowels]
    @letters += %w(k s t n h m).map{|x| @vowels.map{|i|x+i} }
    @letters += [["ya", "", "yu", "", "yo", "", "", ""]]
    @letters += %w(r).map{|x| @vowels.map{|i|x+i} }
    @letters += [["wa", "", "", "", "wo", "", "", ""]]
    @letters += [["n", "", "", "", "", "", "", ""]]
    @letters += %w(g z d b p).map{|x| @vowels.map{|i|x+i} }
    @letters.reverse!
    @letters = @letters.transpose

    @headerH = ["", ""] + %w(k s t n h m y r w) + [""] + %w(g z d b p)
    @headerH.reverse!
    @headerV = @vowels

    #@sentences = Token.where(:pos => 'Satz').order(created_at: 'ASC')
    #@numbers = Token.where(:pos => 'Zahl').order(created_at: 'ASC')
    @tokens = Token.where.not(course: 'JLPT').joins(:token_order).order('tokens.course, tokens.number, token_orders.weight, tokens.category, tokens.hiragana, tokens.katakana, tokens.kanji, tokens.created_at')
    @jlpt_n5 = Token.where(course: 'JLPT').joins(:token_order).order('tokens.course, tokens.number, token_orders.weight, tokens.category, tokens.hiragana, tokens.katakana, tokens.kanji, tokens.created_at')
  end
end
