require './test/test_helper'
require './lib/enigma'

class EnigmaTest < Minitest::Test
  def setup
    @enigma = Enigma.new
  end

  def test_it_exists
    skip
    assert_instance_of Enigma, @engima
  end

  def test_it_can_encrypt_a_message
    expected = {
                message: "hello world",
                key: "02715",
                date: "040895"
                }
    assert_equal expected, @enigma.encrypt("hello world", "02715", "040895")
  end
end
