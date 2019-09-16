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
    key.chars.each_cons(2) { |a, b| key_arr << a + b }
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

  # def encrypt_message(message, key = nil, date = nil)
  #   generate_shift(key, date)
  #   message_arr = message.downcase.chars
  #   message_arr.with_index(1) do |index, value|
  #     puts "#{index}: #{value}"
  #   end
  #   require 'pry'; binding.pry
  # end
end
