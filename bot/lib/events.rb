# Events system
#
# Example:
#
# 	Events::send('client::msg', client, message) => Creates a new event
# 							saying that a new m
# 							essage has been rec
# 							ieved.
#
#	Events::subscribe(object, event, method)     => Calls method on obj
#							ect with the params
#							of event when event
#							is send.
#
#	Events::unsubscribe(object, event, method)   => Opposite of above.
#	               ^ Not implemented ^
require 'thread'

class Events
	def initialize
		@subscribed = []
	end

	def send(name, *params)
		@subscribed.each do
			|event, object, method|
#			puts "Event got: #{name}"
			if event.downcase == name.downcase
				if object.respond_to?(method)
					object.method(method).call(*params)
#					puts "Event sent to #{object.class.to_s}: #{name}"
				end
			end
		end
	end

	def subscribe(object, event, method)
		@subscribed << [event, object, method]
#		puts "#{object.class.to_s} subscribed to #{event}."
	end
end
