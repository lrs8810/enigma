require './lib/random_num_generator'
require './lib/shiftable'
require 'date'

class Encryptor
  include Shiftable
  attr_reader :random_key

  def initialize
    @random_key = RandomNumGenerator.generate_random_num
  end

  def shift_range
    hash = Hash.new(0)
    character_set.each.with_index(1) do | char, index|
      hash[char] = index
    end
    hash
  end

  def final_shift(message, key, date)
    shifts = generate_shift(key, date).values
    shifts.map { |shift| shift % shift_range.length }
  end

  def find_index(message, key, date)
    dc_message = message.downcase.chars
    shift_arr = final_shift(message, key, date)
    final = []
      dc_message.each_with_index do |letter, index|
        final << letter if !character_set.include?(letter)
        final << (shift_arr[0] + shift_range[letter]) if character_set.include?(letter) && index % 4 == 0
        final << (shift_arr[1] + shift_range[letter]) if character_set.include?(letter) && index % 4 == 1
        final << (shift_arr[2] + shift_range[letter]) if character_set.include?(letter) && index % 4 == 2
        final << (shift_arr[3] + shift_range[letter]) if character_set.include?(letter) && index % 4 == 3
      end
    final
  end

  def find_final_index(message, key, date)
    final = find_index(message, key, date)
    final_arr = []
    final.each do |shift|
      if shift.class == String
        final_arr << shift
      elsif shift > 27
        final_arr << shift - shift_range.length
      else
        final_arr << shift
      end
    end
    final_arr
  end

  def build_encryption(message, key, date)
    final_shifts = find_final_index(message, key, date)
    final_shifts.map do |letter|
      if letter.class == String
        letter
      else
        shift_range.key(letter)
      end
    end.join
  end

  def encrypt_message(message, key = nil, date = nil)
    build_encryption(message, key || @random_key, date || current_date)
  end
end
