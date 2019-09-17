require './lib/shiftable'
require 'date'

class Decryptor
  include Shiftable
  def initialize
    @current_date = (DateTime.now.strftime "%d%m%y").to_i
  end

  def decrypt_cipher(cipher, key, date)
    cipher
  end
end
