require 'bot/lib/esocket'

module NotAndy
class Core
	def initialize(config, events, log)
		@config = config
		@events = events
		@log = log
		@socket = NotAndy::Socket::new(@config['server']['addr'], @config['server']['port'], @events)

		## Events

		@events.subscribe(self, 'sock::connected', :on_sock_conn)
		@events.subscribe(self, 'sock::reconnected', :on_sock_conn)
		@events.subscribe(self, 'sock::disconnected', :on_sock_disconn)
	end

	def on_sock_conn
		temp_irc_init
	end

	def on_sock_disconn
		@socket.reconnect
	end

	def temp_irc_init
		@sock.puts "USER test test test :test"
		@sock.puts "NICK NotAndy"
		sleep 3
		@sock.puts "JOIN #geekcouch"
	end
end
end





