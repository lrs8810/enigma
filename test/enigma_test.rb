require './test/test_helper'
require './lib/enigma'

class EnigmaTest < Minitest::Test
  def setup
    @enigma = Enigma.new
  end

  def test_it_exists
    assert_instance_of Enigma, @enigma
  end

  def test_it_can_encrypt_a_message_with_a_key_and_message
    expected = {
                encryption: "keder ohulw",
                key: "02715",
                date: "040895"
                }
    assert_equal expected, @enigma.encrypt("hello world", "02715", "040895")
  end

  def test_it_can_encrypt_a_message_with_a_key_and_today_date
    expected = {
                encryption: "njhauesdxq ",
                key: "02715",
                date: "160919"
                }
    assert_equal expected, @enigma.encrypt("hello world", "02715")
  end
end
