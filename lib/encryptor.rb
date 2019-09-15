require './lib/random_num_generator'
require 'date'

class Encryptor < RandomNumGenerator
  attr_reader :character_set, :current_date, :random_key

  def initialize
    @character_set = ("a".."z").to_a << " "
    @current_date = (DateTime.now.strftime "%d%m%y").to_i
    @random_key = RandomNumGenerator.generate_random_num
  end


  def last_four_digits(date = nil)
    if date == nil
      square_date(@current_date).to_s.slice!(-4..-1).to_i
    else
      square_date(date).to_s.slice!(-4..-1).to_i
    end
  end

  def square_date(date = nil)
    if date == nil
      @current_date * @current_date
    else
      date.to_i * date.to_i
    end
  end
end
