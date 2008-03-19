require File.join(File.dirname(__FILE__), "..", 'spec_helper.rb')

describe CartoonFoxes, "index action" do
  before(:each) do
    dispatch_to(CartoonFoxes, :index)
  end
end