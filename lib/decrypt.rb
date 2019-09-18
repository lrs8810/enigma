require './lib/enigma'

@enigma= Enigma.new

cipher = File.open(ARGV[0], "r")

incoming_cipher = cipher.read

decrypted_message = @enigma.decrypt(incoming_cipher, ARGV[2], ARGV[3] || date = nil)

message = File.open(ARGV[1], "w")

message.write(decrypted_message[:decryption])

message.close

p "Created 'decrypt.txt' with the key #{decrypted_message[:key]} and date #{decrypted_message[:date]}"
