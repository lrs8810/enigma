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

  def test_character_index
    expected = {"a"=>1, "b"=>2, "c"=>3, "d"=>4, "e"=>5, "f"=>6, "g"=>7, "h"=>8, "i"=>9, "j"=>10, "k"=>11, "l"=>12, "m"=>13, "n"=>14, "o"=>15, "p"=>16, "q"=>17, "r"=>18, "s"=>19, "t"=>20, "u"=>21, "v"=>22, "w"=>23, "x"=>24, "y"=>25, "z"=>26, " "=>27}
    assert_equal expected, @encryptor.character_index
  end

  def test_calculate_shift_based_on_character_index
    expected = [3, 0, 19, 20]
    assert_equal expected, @encryptor.calculate_shift_based_on_character_index("Hello World", "02715", "040895")
  end

  def test_find_encrypt_index
    expected = [11, 5, 31, 32, 18, 27, 42, 35, 21, 12, 23]
    assert_equal expected, @encryptor.find_encrypt_index("Hello World", "02715", "040895")

    expected2 = [11, 5, 31, 32, 18, 27, 42, 35, 21, 12, 23, 47, 11, 5, 31, 32, 18, 27, 42, 35, 21, 12, 23]
    assert_equal expected2, @encryptor.find_encrypt_index("HELLO WORLD hello world", "02715", "040895")

    expected3 = [11, 5, 31, 32, 18, 27, 42, 35, 21, 12, 23, "!"]
    assert_equal expected3, @encryptor.find_encrypt_index("HELLO WORLD!", "02715", "040895")
  end

  def test_find_final__encrypt_index
    expected = [11, 5, 4, 5, 18, 27, 15, 8, 21, 12, 23]
    assert_equal expected, @encryptor.find_final_encrypt_index("Hello World", "02715", "040895")

    expected = [11, 5, 4, 5, 18, 27, 15, 8, 21, 12, 23, 20, 11, 5, 4, 5, 18, 27, 15, 8, 21, 12, 23]
    assert_equal expected, @encryptor.find_final_encrypt_index("HELLO WORLD hello world", "02715", "040895")

    expected3 = [11, 5, 4, 5, 18, 27, 15, 8, 21, 12, 23, "!"]
    assert_equal expected3, @encryptor.find_final_encrypt_index("HELLO WORLD!", "02715", "040895")
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
