require 'spec_helper'

describe Causality::SpoolConnector do
  before( :each ) do
    test_spool_path = File.expand_path( 'test_spool', File.dirname( __FILE__ ) )
    @options = { :spool_path => test_spool_path }

    @instance = Causality::SpoolConnector.new( @options )
  end

  describe ".from_yml_file" do
    before( :each ) do
      @yml_data = YAML.dump( @options )
    end

    context "a configuration file was passed" do
      before( :each ) do
        @other_config_file = "some_config_file"
        @other_config_options = { :spool_path => '/some/other/path' }
        @other_yml_data = YAML.dump( { :spool => @other_config_options } )
        File.stub!( :read ).with( @other_config_file ).and_return( @other_yml_data )
      end

      it "should create a SpoolPool instance from the spool section of the passed configuration file" do
        SpoolPool::Pool.should_receive( :new ).with( @other_config_options[:spool_path] )
        Causality::SpoolConnector.from_yml_file( @other_config_file )
      end
    end

    context "no configuration file was passed" do
      before( :each ) do
        @yml_data = YAML.dump( { :spool => @options } )
        File.stub!( :read ).with( Causality::DEFAULT_CONFIG_FILE ).and_return( @yml_data )
      end

      it "should create a SpoolPool instance from the spool section of the default configuration file" do
        SpoolPool::Pool.should_receive( :new ).with( @options[:spool_path] )
        Causality::SpoolConnector.from_yml_file
      end
    end
  end

  it "should have a spooler attribute" do
    @instance.should respond_to( :spooler )
  end

  describe "#initialize" do
    it "should create a SpoolPool instance from the passed options" do
      SpoolPool::Pool.should_receive( :new ).with( @options[:spool_path] )
      Causality::SpoolConnector.new( @options )
    end
  end
end
