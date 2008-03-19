class ChunkyMessages < Application
  before :find_chunky_queue
  before :find_chunky_message, :only => [:show, :destroy]
  only_provides :xml
  
  def index
    @chunky_messages = @chunky_queue.receive_messages(params[:NumberOfMessages])
    render
  end
  
  def show
    render
  end
  
  def create
    @chunky_message = @chunky_queue.push(request.raw_post)
    render
  end
  
  def destroy
    @chunky_message && @chunky_message.destroy
    render
  end
  
  protected
    def find_chunky_queue
      queue_name = params[:chunky_queue_id]
      queue_name += QUEUE_PREFIX unless queue_name =~ Regexp.new(QUEUE_PREFIX)
      @chunky_queue = ChunkyQueue[:name => queue_name]
    end
    
    def find_chunky_message
      @chunky_message = @chunky_queue.messages[:id => params[:id]]
    end
end
