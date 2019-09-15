require './lib/encryptor'
require './lib/decryptor'

class Enigma
  def initialize
    @encryptor = Encryptor.new
  end

end
