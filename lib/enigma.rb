require './lib/encryptor'

class Enigma
  def initialize
    @encryptor = Encryptor.new
  end

  def build_encrypt(message, key, date)
    encryption_hash = {
      encryption: @encryptor.encrypt_message(message, key, date),
      key: key,
      date: date
    }
    encryption_hash
  end

  def encrypt(message, key = nil, date = nil)
    build_encrypt(message, key || @encryptor.random_key, date || @encryptor.current_date.to_s)
  end
end
