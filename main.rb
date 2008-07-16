require 'logger'
require 'bot/lib/events'
require 'bot/lib/config'
require 'bot/core'

@config = Config::new('conf/bot.yaml')

@events = Events::new

@log = Logger::new(@config['log']['location'])
@log.level = Logger::DEBUG

@core = NotAndy::Core::new(@config, @events, @log)

sleep 10000
