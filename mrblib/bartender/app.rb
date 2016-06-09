module Bartender
  class App
    def initialize
      @input = {}
      @output = {}
    end

    def run
      until empty?
        step
      end
    end

    def empty?
      @input.empty? && @output.empty?
    end

    def step(timeout=nil)
      read_set = @input.keys.map {|n| IO.for_fd(n)}
      write_set = @output.keys.map {|n| IO.for_fd(n)}
      r, w = IO.select(read_set, write_set, [], timeout)
      r.each {|fd| @input[fd.to_i].call }
      w.each {|fd| @output[fd.to_i].call }
    end

    def event_map(event)
      case event
      when :read
        @input
      when :write
        @output
      else
        raise 'invalid event'
      end
    end

    def []=(event, fd, callback)
      fd = fd.to_i
      return delete(event, fd) unless callback
      event_map(event)[fd] = callback
    end

    def delete(event, fd)
      event_map(event).delete(fd)
    end
  end
end
