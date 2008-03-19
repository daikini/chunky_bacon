class ChunkyQueues < Application
  only_provides :xml
  
  def index
    @chunky_queues = ChunkyQueue.all
    render
  end
  
  def show
    @chunky_queue = ChunkyQueue[:name => id]
    display @chunky_queue
  end
  
  def create
    queue_name = "#{QUEUE_PREFIX}#{params[:QueueName]}"
    @chunky_queue = ChunkyQueue.create(:name => queue_name, :visibility_timeout => params[:DefaultVisibilityTimeout]) rescue ChunkyQueue[:name => queue_name]
    render
  end
end
