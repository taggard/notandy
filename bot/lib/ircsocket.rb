# Doesn't do much, just sends events if it gets disconnected.
require 'socket'

module IRC
class Socket
	def initialize(server, port, events)
		@server, @port, @events = server, port, events
		@sock = TCPSocket.new(server, port)
		@events.send('sock::connected')
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
		a = @sock.gets.chomp
		if a == nil
			@events.send('sock::disconnected')
			return false
		end
		a
	end
end
end

	
