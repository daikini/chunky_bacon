require File.join(File.dirname(__FILE__), "..", 'spec_helper.rb')

describe Slices, "index action" do
  before(:each) do
    @controller = Slices.build(fake_request)
    @controller.dispatch('index')
  end
end