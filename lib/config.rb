require 'yaml'

# A fake hash that saves itself to a file everytime it is used.
class Config
	def initialize(file)
		@file = file
		@config = Hash.new
		load_config(@file)
	end

	def [](key)
		@config[key]
	end

	def []=(key, value)
		@config[key] = value
		save
	end

	def delete(key)
		@config.delete(key)
		save
	end

	def has_key?(key)
		@config.has_key?(key)
	end

	def save(file = @file)
		File::open('file', 'w') do |out|
			YAML::dump(@config, out)
		end
	end

	def load_config(file = @file)
		@config = YAML::load_file(file) if File.exists?(file)
	end
end
