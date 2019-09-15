require './test/test_helper'
require './lib/random_num_generator'

class RandomNumGeneratorTest < Minitest::Test

  def setup
    @random = RandomNumGenerator.new
  end

  def test_it_exists
    assert_instance_of RandomNumGenerator, @random
  end

  def test_initialize
    assert_nil @random.random_key
  end

  def test_generate
    @random.generate

    assert_equal "01234".length, @random.random_key.length
  end
end
