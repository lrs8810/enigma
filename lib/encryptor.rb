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
    chars = character_set.map(&:ord)
    hash = Hash.new(0)
    chars.each.with_index(1) do | char, index|
      hash[char] = index
    end
    hash
  end

  def final_shift(message, key = nil, date = nil)
    shifts = generate_shift(key, date).values
    shifts.map { |shift| shift % shift_range.length }
  end

  # def find_position(message, key = nil, date = nil)
  #   dc_message = message.downcase.chars
  #   shifts = generate_shift(key, date).values
  #   char_hash = shift_range
  #   final_shifts = shifts.map { |shift| shift % char_hash.length }
  #   final = []
  #   char_hash.each do |ord_val, position|
  #     dc_message.each_with_index do |letter, index|
  #       (final_shifts[0] + char_hash[letter.ord]).chr if character_set.include?(letter) && index % 4 == 0
  #
  #       require 'pry'; binding.pry
  #     end
  # end

  # def shift_message(message, key = nil, date = nil)
  #   shifts = generate_shift(key, date).values
  #   char_hash = shift_range
  #   dc_message = message.downcase.chars
  #   final_shifts = shifts.map { |shift| shift % char_hash.length }
  #   final = []
  #   char_hash.each do |ord_val, position|
  #     dc_message.each_with_index do |letter, index|
  #       final << char_hash.key(final_shifts[0] + char_hash[letter.ord]).chr if character_set.include?(letter) && index % 4 == 0
  #       final << char_hash.key(final_shifts[1] + char_hash[letter.ord]).chr if character_set.include?(letter) && index % 4 == 1
  #       final << char_hash.key(final_shifts[2] + char_hash[letter.ord]).chr if character_set.include?(letter) && index % 4 == 2
  #       final << char_hash.key(final_shifts[3] + char_hash[letter.ord]).chr if character_set.include?(letter) && index % 4 == 3
  #       require 'pry'; binding.pry
  #     end
  #   end
  #   final.join
  # end
end
