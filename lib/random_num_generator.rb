class RandomNumGenerator
  attr_reader :random_key

  def initialize
    @random_key = nil
  end

  def generate
    @random_key = rand(100_000).to_s.rjust(5, "0")
  end

  # def self.generate_random_num
  #   rand(100_000).to_s.rjust(5, "0")
  # end
end
