require 'yaml'

module Causality
  DEFAULT_CONFIG_FILE = "causality.yml"

  class QueueUnavailable < StandardError ; end
end

$: << File.expand_path( File.dirname( __FILE__ ) )

require 'causality/queue_connector'
require 'causality/spool_connector'
require 'causality/event'
require 'causality/collector'
require 'causality/dispatcher'
require 'causality/rule_loader'
require 'causality/rule'
