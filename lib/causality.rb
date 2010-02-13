require 'yaml'

module Causality
  DEFAULT_CONFIG_FILE = "causality.yml"
end

$: << File.expand_path( File.dirname( __FILE__ ) )

require 'causality/queue_connector'
require 'causality/event'
require 'causality/collector'
