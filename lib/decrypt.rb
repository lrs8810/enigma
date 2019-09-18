require './lib/enigma'

@enigma= Enigma.new

cipher = File.open(ARGV[0], "r")

incoming_cipher = cipher.read

decrypt_message = @enigma.decrypt(incoming_cipher, ARGV[2], ARGV[3] || current_date)

message = File.open(ARGV[1], "w")

message.write(decrypt_message[:decryption])

message.close

p "Created 'decrypt.txt' with the key #{decrypt_message[:key]} and date #{decrypt_message[:date]}"
