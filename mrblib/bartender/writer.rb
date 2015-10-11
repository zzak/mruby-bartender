module Bartender
  class Writer
    def initialize(bartender, fd)
      @bartender = bartender
      @fd = fd
      @pool = []
    end

    def select_writable
      @bartender[:write, @fd] = Fiber.current.method(:resume)
      Fiber.yield
    ensure
      @bartender.delete(:write, @fd)
    end

    def _write(buf)
      return @fd.write_nonblock(buf)
    rescue IO::WaitWritable
      select_writable
      retry
    end

    def write(buf)
      push(buf)
      until @pool.empty?
        len = _write(@pool[0])
        pop(len)
      end
    end

    private
    def push(string)
      return if string.bytesize == 0
      @pool << string
    end

    def pop(size)
      return if size < 0
      raise if @pool[0].bytesize < size

      if @pool[0].bytesize == size
        @pool.shift
      else
        unless @pool[0].encoding == Encoding::BINARY
          @pool[0] = @pool[0].dup.force_encoding(Encoding::BINARY)
        end
        @pool[0].slice!(0...size)
      end
    end
  end
end
