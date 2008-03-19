require File.join(File.dirname(__FILE__), "..", 'spec_helper.rb')

describe Instances, "index action" do
  before(:each) do
    dispatch_to(Instances, :index)
  end
end