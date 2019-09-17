require './lib/shiftable'
require 'date'

class Decryptor
  include Shiftable
  def initialize
    @current_date = (DateTime.now.strftime "%d%m%y").to_i
  end

  def find_index(cipher, key, date)
    cipher_letters = cipher.chars
    shift_arr = calculate_shift_based_on_character_index(cipher, key, date)
    message = []
      cipher_letters.each_with_index do |letter, index|
        message << letter if !character_set.include?(letter)
        message << (character_index[letter] - shift_arr[0]) if character_set.include?(letter) && index % 4 == 0
        message << (character_index[letter] - shift_arr[1]) if character_set.include?(letter) && index % 4 == 1
        message << (character_index[letter] - shift_arr[2]) if character_set.include?(letter) && index % 4 == 2
        message << (character_index[letter] - shift_arr[3]) if character_set.include?(letter) && index % 4 == 3
      end
    message
  end

  def find_final_index(cipher, key, date)
    final = find_index(cipher, key, date)
    final_arr = []
    final.each do |shift|
      if shift.class == String
        final_arr << shift
      elsif shift < 0
        final_arr << shift + character_index.length
      else
        final_arr << shift
      end
    end
    final_arr
  end

  def build_decryption(message, key, date)
    final_shifts = find_final_index(message, key, date)
    final_shifts.map do |letter|
      if letter.class == String
        letter
      else
        character_index.key(letter)
      end
    end.join
  end

  def decrypt_cipher(cipher, key, date)
    build_decryption(cipher, key, date || current_date)
  end
end
