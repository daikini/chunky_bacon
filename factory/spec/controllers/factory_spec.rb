require File.join(File.dirname(__FILE__), "..", 'spec_helper.rb')

describe Factory, "index action" do
  before(:each) do
    @controller = Factory.build(fake_request)
    @controller.dispatch('index')
  end
end