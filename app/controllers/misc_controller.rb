class MiscController < ApplicationController
  def print
    @poses = Token.select(:pos).order(:pos).map(&:pos).uniq
    @poses = @poses - %w{Satz Buchstabe}

    @sentences = Token.where(:pos => 'Satz').order(created_at: 'ASC')
    @tokens = Token.where(:pos => @poses).order(pos: 'ASC', created_at: 'ASC')
  end
end
