require File.join(File.dirname(__FILE__), "..", 'spec_helper.rb')

describe ChunkyQueues, "index action" do
  before(:each) do
    @controller = ChunkyQueues.build(fake_request)
    @controller.dispatch('index')
  end
end