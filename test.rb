soc = TCPServer.new('localhost', 9999)
fd = soc.accept
puts fd.to_i
exit

app = Bartender::App.new
Bartender::Server.new(app, 9999) do |reader, writer|
  puts "hello"
end
app.run
