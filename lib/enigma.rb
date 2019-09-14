class Enigma
  def initialize
    @input = {}
  end

  def encrypt(message, key, date)
    @input[:message] = message
    @input[:key] = key
    @input[:date] = date
    @input
  end
end
