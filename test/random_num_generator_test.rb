require './test/test_helper'
require './lib/random_num_generator'

class RandomNumGeneratorTest < Minitest::Test

  def test_it_can_generate_random_key
    assert_equal "01234".length, RandomNumGenerator.generate_random_num.length
    assert_equal true, RandomNumGenerator.generate_random_num.length !~ /\D/
  end
end
