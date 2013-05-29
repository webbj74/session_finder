require 'yaml'

module SessionFinder

  class Configuration
    attr_reader :config

    def initialize(filename = nil)
      filename ||= 'session_finder.yml'
      @config = YAML.load_file(filename)
    rescue Errno::ENOENT
      puts "The specified configuration file doesn't exist! (#{filename})"
      exit
    end

  end

end

