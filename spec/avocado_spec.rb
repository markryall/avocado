describe Avocado do
  it "should have default host" do
    Avocado.host.must_equal 'avocado.io'
  end

  it "should have default port" do
    Avocado.port.must_equal 443
  end
end
