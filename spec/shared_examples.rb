shared_examples_for "an abstract method" do
  it "should raise an exception when called" do
    lambda { @instance.send( @method ) }.should raise_error( RuntimeError )
  end
end
