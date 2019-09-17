require './lib/random_num_generator'
require 'date'

class Encryptor
  attr_reader :random_key

  def initialize
    @random_key = RandomNumGenerator.generate_random_num
  end

  def character_set
    @character_set ||= ("a".."z").to_a << " "
  end

  def current_date
    @current_date ||= (DateTime.now.strftime "%d%m%y").to_i
  end

  def square_date(date)
    date.to_i * date.to_i
  end

  def last_four_digits(date)
    square_date(date).to_s.slice!(-4..-1).chars.map(&:to_i)
  end

  def symbol_key
    @symbol_key ||= (:A..:D).to_a
  end

  def build_offset(date)
    last_four = last_four_digits(date)
    symbol_key.zip(last_four).to_h
  end

  def generate_offset(date = nil)
    build_offset(date || current_date)
  end

  def split_key(key)
    key_arr = []
    key.chars.each_cons(2) { |elem_1, elem_2| key_arr << elem_1 + elem_2 }
    key_arr.map(&:to_i)
  end

  def build_keys(key)
    values = split_key(key)
    symbol_key.zip(values).to_h
  end

  def generate_keys(key = nil)
    build_keys(key || @random_key)
  end

  def build_shift(key, date)
    keys_hash = generate_keys(key)
    offset_hash = generate_offset(date)
    keys_hash.merge!(offset_hash) { |sym, k_val, o_val| k_val + o_val }
  end

  def generate_shift(key = nil, date = nil)
    build_shift(key || @random_key, date || current_date)
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
