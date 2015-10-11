module Bartender
  class Server
    def initialize(bartender, port, &blk)
      @bartender = bartender
      @server = TCPServer.new(port)
      @bartender[:read, @server] = self.method(:on_accept)
      @blk = blk
    end

    def on_accept
      client = @server.accept
      reader = Reader.new(@bartender, client)
      writer = Writer.new(@bartender, client)
      fiber = Fiber.new do
        @blk.yield(reader, writer)
      end
      fiber.resume
    end
  end
end
