module Merb
  module GlobalHelpers
    # helpers defined here available to all views.
    def full_url(*args)
      request.protocol + request.host + url(*args)
    end  
  end
end
