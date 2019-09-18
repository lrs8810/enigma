require './lib/random_num_generator'
require './lib/shiftable'
require 'date'

class Encryptor
  include Shiftable
  attr_reader :random_key, :current_date

  def initialize
    @random_key = RandomNumGenerator.generate_random_num
    @current_date = (DateTime.now.strftime "%d%m%y").to_i
  end

  def find_encrypt_index(message, key, date)
    dc_message = message.downcase.chars
    shifts_key = calculate_shift_based_on_character_index(message, key, date)
    indexes = []
      dc_message.each_with_index do |letter, index|
        indexes << letter if !character_set.include?(letter)
        indexes << (shifts_key[0] + character_index[letter]) if character_set.include?(letter) && index % 4 == 0
        indexes << (shifts_key[1] + character_index[letter]) if character_set.include?(letter) && index % 4 == 1
        indexes << (shifts_key[2] + character_index[letter]) if character_set.include?(letter) && index % 4 == 2
        indexes << (shifts_key[3] + character_index[letter]) if character_set.include?(letter) && index % 4 == 3
      end
    indexes
  end

  def find_final_encrypt_index(message, key, date)
    indexes = find_encrypt_index(message, key, date)
    indexes.inject([]) do |final_indexes, shift|
      if shift.class == Integer && shift > 27
        final_indexes << shift - character_index.length
      else
        final_indexes << shift
      end
    end
  end

  def build_encryption(message, key, date)
    final_shifts = find_final_encrypt_index(message, key, date)
    final_shifts.map do |letter|
      if letter.class == String
          letter
        else
          character_index.key(letter)
      end
    end.join
  end

  def encrypt_message(message, key = nil, date = nil)
    build_encryption(message, key || @random_key, date || @current_date)
  end
end
