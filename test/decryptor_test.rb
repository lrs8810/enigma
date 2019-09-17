require './test/test_helper'
require './lib/encryptor'

class DecryptorTest < Minitest::Test
  def setup
    @decryptor = Decryptor.new
  end

  def test_it_exists
    assert_instance_of Decryptor, @decryptor
  end

  def test_decrypt_message
    assert_equal "hello world", @decryptor.decrypt_cipher("keder ohulw", "02715", "040895")
  end
end
