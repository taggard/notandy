require 'lib/ircsocket'

module Bot
class Core
	attr_reader :connected
	# This is like a general, main-loop-ish, kinda class.
	# It'll initialize the bot when Core#new is called, a
	# nd keep things running. 
	
	def initialize(config, log, events)
		@log = log
		@events = events
		@config = config

		# Events
		@events::subscribe(self, 'sock::disconnected', :on_sock_disconn)
		@events::subscribe(self, 'sock::connected', :on_sock_conn)
		@events::subscribe(self, 'sock::reconnected', :on_sock_conn)

		# Socket
		@sock = IRC::Socket::new(@config['server']['addr'], @config['server']['port'], @events)
	end

	def parser_loop
		while @connected
			line = @sock.gets
			if line =~ /PING/
				send("PONG irc.notandy.com")
			end
		end
	end

	def on_sock_disconn
		@connected = false
	end

	def on_sock_conn
		@connected = true
		Thread.new { parser_loop }
	end

	private

	def send(text)
		@sock.puts text
	end
end
end

