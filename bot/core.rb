require 'bot/lib/ircsocket'

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
		@connected = false

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
		@events::send('bot::cant_send')
	end

	def on_sock_conn
		@connected = true
		irc_init
		Thread.new { parser_loop }
	end

	private

	def send(text)
		@sock.puts text if @connected
	end

	def irc_init
		id = @config['bot']['ident']
		send("USER #{id} #{id} #{id} :#{@config['bot']['gecos']}")
		send("NICK #{@config['bot']['nick']}")
		sleep 3 # Register
		@config['channels'].each do
			|chan|
			send("JOIN #{chan}")
		end
		@events::send('bot::can_send')
	end
end
end

