module Causality
end

$: << File.expand_path( File.dirname( __FILE__ ) )

require 'causality/queue_connector'
require 'causality/event'
require 'causality/collector'
