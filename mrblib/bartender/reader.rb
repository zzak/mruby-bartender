module Bartender
  class Reader
    def initialize(bartender, fd)
      @bartender = bartender
      @buf = ''
      @fd = fd
    end

    def read(n)
      while @buf.bytesize < n
        chunk = _read(n)
        break if chunk.nil? || chunk.empty?
        @buf += chunk
      end
      @buf.slice!(0, n)
    end

    def read_until(sep="\r\n", chunk_size=8192)
      until (index = @buf.index(sep))
        @buf += _read(chunk_size)
      end
      @buf.slice!(0, index+sep.bytesize)
    end

    def readln
      read_until("\n")
    end

    private
    def _read(n)
      @fd.read_nonblock(n)
    rescue IO::WaitReadable
      select_readable
      retry
    end

    def select_readable
      @bartender[:read, @fd] = Fiber.current.method(:resume)
      Fiber.yield
    ensure
      @bartender.delete(:read, @fd)
    end
  end
end
