# Doesn't do much, just sends events if it gets disconnected.
require 'socket'

module IRC
class Socket < TCPSocket
	def initialize(server, port, events)
		@server, @port, @events = server, port, events
		@sock = super(server, port)
		@events.send('sock::connected', self)
	end

	def reconnect(server = @server, port = @port)
		@sock.close
		@sock = TCPSocket.new(server, port)
		@events.send('sock::reconnected')
	end

	def puts(text)
		a = @sock.puts text.to_s.chomp
		if a == []
			@events.send('sock::disconnected')
			return false
		end
		a
	end

	def gets
		puts "hi"
		a = @sock.gets.chomp
		puts "< #{a}"
		if a == nil
			@events.send('sock::disconnected')
			return false
		end
		a
	end
end
end
