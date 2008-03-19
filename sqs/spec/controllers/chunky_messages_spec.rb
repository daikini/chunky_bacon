require File.join(File.dirname(__FILE__), "..", 'spec_helper.rb')

describe ChunkyMessages, "index action" do
  before(:each) do
    @controller = ChunkyMessages.build(fake_request)
    @controller.dispatch('index')
  end
end