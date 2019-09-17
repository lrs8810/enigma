module Shiftable
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

  def character_index
    hash = Hash.new(0)
    character_set.each.with_index(1) do | char, index|
      hash[char] = index
    end
    hash
  end

  def calculate_shift_based_on_character_index(message, key, date)
    shifts = generate_shift(key, date).values
    shifts.map { |shift| shift % character_index.length }
  end
end
