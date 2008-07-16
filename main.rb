require 'logger'
require 'events'
require 'core'
require 'config'

@config = Config::new('conf/bot.yaml')

@events = Events::new

@log = Logger::new(@config['log']['location'])
@log.level = Logger::WARN

@core = Bot::Core::new(@config, @log, @events)
