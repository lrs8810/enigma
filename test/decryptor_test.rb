require './test/test_helper'
require './lib/decryptor'

class DecryptorTest < Minitest::Test
  def setup
    @decryptor = Decryptor.new
  end

  def test_it_exists
    assert_instance_of Decryptor, @decryptor
  end

  def test_initialize
    assert_equal 180919, @decryptor.current_date
  end

  def test_character_set
    expected = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z", " "]
    assert_equal expected, @decryptor.character_set
  end

  def test_square_date
    assert_equal 1672401025, @decryptor.square_date("040895")
  end

  def test_last_four_digits
    assert_equal [1, 0, 2, 5], @decryptor.last_four_digits("040895")
  end

  def test_symbol_key
    assert_equal [:A, :B, :C, :D], @decryptor.symbol_key
  end

  def test_build_offset
    expected = {A:1, B:0, C:2, D:5}
    assert_equal expected, @decryptor.generate_offset("040895")
  end

  def test_generate_offset_can_take_an_argument_or_no_argument
    expected = {A:1, B:0, C:2, D:5}
    assert_equal expected, @decryptor.generate_offset("040895")

    expected2 = {A:4, B:5, C:6, D:1}
    assert_equal expected2, @decryptor.generate_offset
  end

  def test_split_key
    expected = [2, 27, 71, 15]
    assert_equal expected, @decryptor.split_key("02715")
  end

  def test_build_keys
    expected = {A:2, B:27, C:71, D:15}
    assert_equal expected, @decryptor.generate_keys("02715")
  end

  def test_generate_keys_can_take_an_argument
    expected = {A:2, B:27, C:71, D:15}
    assert_equal expected, @decryptor.generate_keys("02715")
  end

  def test_build_shift
    expected = {A:3, B:27, C:73, D:20}

    assert_equal expected, @decryptor.generate_shift("02715", "040895")
  end

  def test_generate_shift_can_take_a_key_with_or_without_date
    expected = {A:3, B:27, C:73, D:20}

    assert_equal expected, @decryptor.generate_shift("02715", "040895")

    expected2 = {A:6, B:32, C:77, D:16}
    assert_equal expected2, @decryptor.generate_shift("02715")
  end

  def test_character_index
    expected = {"a"=>1, "b"=>2, "c"=>3, "d"=>4, "e"=>5, "f"=>6, "g"=>7, "h"=>8, "i"=>9, "j"=>10, "k"=>11, "l"=>12, "m"=>13, "n"=>14, "o"=>15, "p"=>16, "q"=>17, "r"=>18, "s"=>19, "t"=>20, "u"=>21, "v"=>22, "w"=>23, "x"=>24, "y"=>25, "z"=>26, " "=>27}
    assert_equal expected, @decryptor.character_index
  end

  def test_it_can_calculate_based_on_character_index
    expected = [3, 0, 19, 20]
    assert_equal expected, @decryptor.calculate_shift_based_on_character_index("keder ohulw", "02715", "040895")
  end

  def test_find_cipher_index
    expected = [8, 5, -15, -15, 15, 27, -4, -12, 18, 12, 4]
    assert_equal expected, @decryptor.find_cipher_index("keder ohulw", "02715", "040895")
  end

  def test_find_final_cipher_index
    expected = [8, 5, 12, 12, 15, 27, 23, 15, 18, 12, 4]
    assert_equal expected, @decryptor.find_final_cipher_index("keder ohulw", "02715", "040895")
  end

  def test_build_decryption
    assert_equal "hello world", @decryptor.build_decryption("keder ohulw", "02715", "040895")
    assert_equal "hello world hello world", @decryptor.build_decryption("keder ohulwtkeder ohulw", "02715", "040895")
    assert_equal "hello world!", @decryptor.build_decryption("keder ohulw!", "02715", "040895")
  end

  def test_decrypt_cipher
    assert_equal "hello world", @decryptor.decrypt_cipher("keder ohulw", "02715", "040895")
    assert_equal "hello world hello world", @decryptor.decrypt_cipher("keder ohulwtkeder ohulw", "02715", "040895")
    assert_equal "hello world!", @decryptor.decrypt_cipher("keder ohulw!", "02715", "040895")
    assert_equal "hello!world", @decryptor.decrypt_cipher("keder!ohulw", "02715", "040895")
  end
end
