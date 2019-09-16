require './lib/random_num_generator'
require 'date'

class Encryptor < RandomNumGenerator
  attr_reader :character_set, :current_date, :random_key

  def initialize
    @character_set = ("a".."z").to_a << " "
    @current_date = (DateTime.now.strftime "%d%m%y").to_i
    @random_key = RandomNumGenerator.generate_random_num
  end

  def generate_offset(date = nil)
    if date == nil
      offset_hash = Hash.new(0)
      offset_key = (:A..:D).to_a
      last_four_arr = last_four_digits(@current_date).to_s.chars.map(&:to_i)
      offset_key.zip(last_four_arr) {|key, value| offset_hash[key] = value}
      offset_hash
    else
      offset_hash = Hash.new(0)
      offset_key = (:A..:D).to_a
      last_four_arr = last_four_digits(date).to_s.chars.map(&:to_i)
      offset_key.zip(last_four_arr) {|key, value| offset_hash[key] = value}
      offset_hash
    end
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

  def generate_keys(key = nil)
    if key == nil
      keys_hash = Hash.new(0)
      symbol_arr = (:A..:D).to_a
      values_arr = split_key(@random_key).map(&:to_i)
      symbol_arr.zip(values_arr) {|symbol, value| keys_hash[symbol] = value}
      keys_hash
    else
      keys_hash = Hash.new(0)
      symbol_arr = (:A..:D).to_a
      values_arr = split_key(key).map(&:to_i)
      symbol_arr.zip(values_arr) {|symbol, value| keys_hash[symbol] = value}
      keys_hash
    end
  end

  def split_key(key = nil)
    if key == nil
      key_arr = []
      @random_key.chars.each_cons(2) { |a, b| key_arr << a + b }
      key_arr
    else
      key_arr = []
      key.chars.each_cons(2) { |a, b| key_arr << a + b }
      key_arr
    end
  end

  def generate_shift(key = nil, date = nil)
    if key == nil && date == nil
      keys_hash = generate_keys(@random_key)
      offset_hash = generate_offset(@current_date)
      keys_hash.merge!(offset_hash) do |symbol, key_val, offset_val|
        key_val + offset_val
      end
      keys_hash
    else
      keys_hash = generate_keys(key)
      offset_hash = generate_offset(date)
      keys_hash.merge!(offset_hash) do |symbol, key_val, offset_val|
        key_val + offset_val
      end
      keys_hash
    end
  end
end
