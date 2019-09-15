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
    expected = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z", " "]
    assert_equal expected, @encryptor.character_set
    assert_equal 150919, @encryptor.current_date
    assert_equal "01234".length, @encryptor.random_key.length
  end

  def test_square_date
    assert_equal 22776544561, @encryptor.square_date
    assert_equal 1672401025, @encryptor.square_date("040895")
  end

  def test_last_four_digits
    assert_equal 1025, @encryptor.last_four_digits("040895")
    assert_equal 4561, @encryptor.last_four_digits
  end

  def test_generate_offset
    expected = {A:1, B:0, C:2, D:5}
    assert_equal expected, @encryptor.generate_offset("040895")

    expected2 = {A:4, B:5, C:6, D:1}
    assert_equal expected2, @encryptor.generate_offset
  end

  def test_split_key
    expected = ["02", "27", "71", "15"]
    assert_equal expected, @encryptor.split_key("02715")

    assert_equal expected.length, @encryptor.split_key.length
  end

  def test_generate_keys
    assert_equal 
  end
end
