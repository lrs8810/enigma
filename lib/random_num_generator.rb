class RandomNumGenerator
  def self.generate_random_num
    rand(100_000).to_s.rjust(5, "0")
  end
end
