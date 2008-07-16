require 'bot/esocket'

module NotAndy
class Core
	def initialize(config, events, log)
		@config = config
		@events = events
		@log = log	

		## Events

		@events.subscribe(self, 'sock::connected', :on_sock_conn)
		@events.subscribe(self, 'sock::reconnected', :on_sock_conn)
		@events.subscribe(self, 'sock::disconnected', :on_sock_disconn)

		## Socket
		
		@socket = NotAndy::Socket::new(@config['server']['addr'], @config['server']['port'], @events)
	end

	def on_sock_conn(socket = @socket)
		@socket = socket
		temp_irc_init
	end

	def on_sock_disconn
		@socket.reconnect
	end

	def temp_irc_init
		@socket.puts "USER test test test :test"
		@socket.puts "NICK NotAndy"
		sleep 3
		@socket.puts "JOIN #geekcouch"
	end
end
end
