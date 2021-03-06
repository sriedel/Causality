require 'spec/stubs/cucumber'
require 'starling'
require 'spool_pool'

require 'lib/causality'

Before do
  $rspec_mocks ||= Spec::Mocks::Space.new
end

After do
  begin
    $rspec_mocks.verify_all
  ensure
    $rspec_mocks.reset_all
  end
end
