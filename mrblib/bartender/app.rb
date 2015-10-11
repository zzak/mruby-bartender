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
      r, w = IO.select(@input.keys, @output.keys, [], timeout)
      r.each {|fd| @input[fd].call }
      w.each {|fd| @output[fd].call }
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
      return delete(event, fd) unless callback
      event_map(event)[fd] = callback
    end

    def delete(event, fd)
      event_map(event).delete(fd)
    end
  end
end
