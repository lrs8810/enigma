require './test/test_helper'
require './lib/encryptor'

class DecryptorTest < Minitest::Test
  def setup
    @decryptor = Decryptor.new
  end

  def test_it_exists
    assert_instance_of Decryptor, @decryptor
  end

  def test_its_initial_index
    expected = [11, 5, 4, 5, 18, 27, 15, 8, 21, 12, 23]
    assert_equal expected, @decryptor.calculate_initial_index("keder ohulw", "02715", "040895")
    expected = [11, 5, 4, 5, 18, 27, 15, 8, 21, 12, 23, 20, 11, 5, 4, 5, 18, 27, 15, 8, 21, 12, 23]
    assert_equal expected, @decryptor.calculate_initial_index("keder ohulwtkeder ohulw", "02715", "040895")
  end

  def test_it_can_calculate_based_on_character_index
    expected = [3, 0, 19, 20]
    assert_equal expected, @decryptor.calculate_shift_based_on_character_index("keder ohulw", "02715", "040895")
  end

  def test_find_cipher_index
    expected = [8, 5, -15, -15, 15, 27, -4, -12, 18, 12, 4]
    assert_equal expected, @decryptor.find_index("keder ohulw", "02715", "040895")
  end

  def test_find_final_cipher_index
    expected = [8, 5, 12, 12, 15, 27, 23, 15, 18, 12, 4]
    assert_equal expected, @decryptor.find_final_index("keder ohulw", "02715", "040895")
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
