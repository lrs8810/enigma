require './test/test_helper'
require './lib/encryptor'

class EncryptorTest < Minitest::Test
  def setup
    @encryptor = Encryptor.new
  end

  def test_it_exists
    assert_instance_of Encryptor, @encryptor
  end

  def test_initialize
    assert_equal "01234".length, @encryptor.random_key.length
  end

  def test_character_set
    expected = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z", " "]
    assert_equal expected, @encryptor.character_set
  end

  def test_current_date
    assert_equal 160919, @encryptor.current_date
  end

  def test_square_date
    assert_equal 1672401025, @encryptor.square_date("040895")
  end

  def test_last_four_digits
    assert_equal [1, 0, 2, 5], @encryptor.last_four_digits("040895")
  end

  def test_symbol_key
    assert_equal [:A, :B, :C, :D], @encryptor.symbol_key
  end

  def test_build_offset
    expected = {A:1, B:0, C:2, D:5}
    assert_equal expected, @encryptor.generate_offset("040895")
  end

  def test_generate_offset_can_take_an_argument_or_no_argument
    expected = {A:1, B:0, C:2, D:5}
    assert_equal expected, @encryptor.generate_offset("040895")

    expected2 = {A:4, B:5, C:6, D:1}
    assert_equal expected2, @encryptor.generate_offset
  end

  def test_split_key
    expected = [2, 27, 71, 15]
    assert_equal expected, @encryptor.split_key("02715")
  end

  def test_build_keys
    expected = {A:2, B:27, C:71, D:15}
    assert_equal expected, @encryptor.generate_keys("02715")
  end

  def test_generate_keys_can_take_an_argument_or_no_argument
    expected = {A:2, B:27, C:71, D:15}
    assert_equal expected, @encryptor.generate_keys("02715")

    assert_equal expected.length, @encryptor.generate_keys.length
  end

  def test_build_shift
    expected = {A:3, B:27, C:73, D:20}

    assert_equal expected, @encryptor.generate_shift("02715", "040895")
  end

  def test_generate_shift_can_take_an_argument_or_no_argument
    expected = {A:3, B:27, C:73, D:20}

    assert_equal expected, @encryptor.generate_shift("02715", "040895")

    expected2 = {A:6, B:32, C:77, D:16}
    assert_equal expected2, @encryptor.generate_shift("02715")

    expected3 = {A:6, B:32, C:77, D:16}
    assert_equal expected3.length, @encryptor.generate_shift.length
  end

  def test_shift_range
    expected = {97=>1, 98=>2, 99=>3, 100=>4, 101=>5, 102=>6, 103=>7, 104=>8, 105=>9, 106=>10, 107=>11, 108=>12, 109=>13, 110=>14, 111=>15, 112=>16, 113=>17, 114=>18, 115=>19, 116=>20, 117=>21, 118=>22, 119=>23, 120=>24, 121=>25, 122=>26, 32=>27}
    assert_equal expected, @encryptor.shift_range
  end

  def test_final_shift
    expected = [3, 0, 19, 20]
    assert_equal expected, @encryptor.final_shift("Hello World", "02715", "040895")
  end

  def test_find_index
    expected = [11, 5, 31, 32, 18, 27, 42, 35, 21, 12, 23]
    assert_equal expected, @encryptor.find_index("Hello World", "02715", "040895")
    expected2 = [11, 5, 31, 32, 18, 27, 42, 35, 21, 12, 23, 47, 11, 5, 31, 32, 18, 27, 42, 35, 21, 12, 23]
    assert_equal expected2, @encryptor.find_index("HELLO WORLD hello world", "02715", "040895")
    expected3 = [11, 5, 31, 32, 18, 27, 42, 35, 21, 12, 23, "!"]
    assert_equal expected3, @encryptor.find_index("HELLO WORLD!", "02715", "040895")
  end

  def test_find_final_index
    expected = [11, 5, 4, 5, 18, 27, 15, 8, 21, 12, 23]
    assert_equal expected, @encryptor.find_final_index("Hello World", "02715", "040895")
    expected = [11, 5, 4, 5, 18, 27, 15, 8, 21, 12, 23, 20, 11, 5, 4, 5, 18, 27, 15, 8, 21, 12, 23]
    assert_equal expected, @encryptor.find_final_index("HELLO WORLD hello world", "02715", "040895")
    expected3 = [11, 5, 4, 5, 18, 27, 15, 8, 21, 12, 23, "!"]
    assert_equal expected3, @encryptor.find_final_index("HELLO WORLD!", "02715", "040895")
  end

  def test_build_encryption
    assert_equal "keder ohulw", @encryptor.build_encryption("Hello World", "02715", "040895")
    assert_equal "keder ohulwtkeder ohulw", @encryptor.build_encryption("HELLO WORLD hello world", "02715", "040895")
    assert_equal "keder ohulw!", @encryptor.build_encryption("HELLO WORLD!", "02715", "040895")
  end

  def test_encrypt_message
    assert_equal "keder ohulw", @encryptor.encrypt_message("Hello World", "02715", "040895")
    assert_equal "keder ohulwtkeder ohulw", @encryptor.encrypt_message("HELLO WORLD hello world", "02715", "040895")
    assert_equal "keder ohulw!", @encryptor.encrypt_message("HELLO WORLD!", "02715", "040895")
    assert_equal "keder!ohulw", @encryptor.encrypt_message("HELLO!WORLD", "02715", "040895")
  end
end
