# Doesn't do much, just sends events if it gets disconnected.
require 'socket'

module NotAndy 
class Socket < TCPSocket
	def initialize(server, port, events)
		@server, @port, @events = server, port, events
		@sock = super(server, port)
		@events.send('sock::connected', self)
		@active = true
		Thread.new { elephants }
	end

	def reconnect(server = @server, port = @port)
		@active = false
		@sock.close
		@sock = TCPSocket.new(server, port)
		@events.send('sock::reconnected')
		@active = true
	end

	def elephants
		while true
			next unless @active
			newl = @sock.gets.chomp
			if !newl
				@active = false
				@events.send('sock::disconnected')
				next
			end
			@events.send('sock::newline', newl) 
		end
	end
end
end
