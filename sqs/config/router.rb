# Merb::Router is the request routing mapper for the merb framework.
#
# You can route a specific URL to a controller / action pair:
#
#   r.match("/contact").
#     to(:controller => "info", :action => "contact")
#
# You can define placeholder parts of the url with the :symbol notation. These
# placeholders will be available in the params hash of your controllers. For example:
#
#   r.match("/books/:book_id/:action").
#     to(:controller => "books")
#   
# Or, use placeholders in the "to" results for more complicated routing, e.g.:
#
#   r.match("/admin/:module/:controller/:action/:id").
#     to(:controller => ":module/:controller")
#
# You can also use regular expressions, deferred routes, and many other options.
# See merb/specs/merb/router.rb for a fairly complete usage sample.

Merb.logger.info("Compiling routes...")
Merb::Router.prepare do |r|
  r.match("/chunky_queues/:chunky_queue_id").defer_to do |request, params|
    if params[:Action] == "DeleteMessage"
      params.merge(:controller => "chunky_messages", :action => "destroy", :id => params[:MessageId])
    end
  end
  
  r.match("/chunky_queues/:chunky_queue_id").to(:controller => "chunky_messages") do |chunky_messages|
    # Push a message onto the queue
    chunky_messages.match("/back").to(:action => "create").name(:push)
    
    # Get messages from the queue
    chunky_messages.match("/front").to(:action => "index").name(:receive)
    
    # Peek at a message
    chunky_messages.match("/:id").to(:action => "show").name(:peek)
  end
  
  r.resources :chunky_queues do |chunky_queue|
    chunky_queue.resources :chunky_messages
  end
  
  r.match("/").defer_to do |request, params|
    params.merge(:controller => "chunky_queues", :action => (params[:Action] == "CreateQueue" ? "create" : "index"))
  end
end