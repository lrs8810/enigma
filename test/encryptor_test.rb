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
end
