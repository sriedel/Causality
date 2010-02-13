require 'spool_pool'

module Causality
  class SpoolConnector
    attr_reader :spooler

    def self.from_yml_file( configfile = Causality::DEFAULT_CONFIG_FILE ) 
      new( YAML.load( File.read( configfile ) )[:spool] )
    end

    def initialize( options )
      @spooler = SpoolPool::Pool.new( options[:spool_path] )
    end

    def set( queue, value )
      @spooler.put queue, value
    end
  end
end
