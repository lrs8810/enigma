require './lib/enigma'

@enigma= Enigma.new

message = File.open(ARGV[0], "r")

incoming_message = message.read

message.close

encrypted_message = @enigma.encrypt(incoming_message)

cipher = File.open(ARGV[1], "w")

cipher.write(encrypted_message[:encryption])

cipher.close

p "Created '/encrypt.txt/' with the key #{encrypted_message[:key]} and date #{encrypted_message[:date]}"
