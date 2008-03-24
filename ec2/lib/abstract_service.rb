class AbstractService
  MIN_STATUS_INTERVAL = 2
  
  attr_accessor :instance_id, :last_busy_send, :last_idle_send, :last_time
  def initialize(instance_id)
    @instance_id = instance_id
    @last_time = (Time.now - MIN_STATUS_INTERVAL - 1)
    @last_busy_send = @last_time
    @last_idle_send = @last_time
  end
  
  def send_status_update(busy)
    now = Time.now
    if (busy && (now - last_busy_send) > MIN_STATUS_INTERVAL) ||
  		(!busy && (now - last_idle_send) > MIN_STATUS_INTERVAL)

  		interval = now - last_time
  		status = {:instance_id => instance_id, :last_interval => interval, :state => (busy ? "busy" : "idle")}.to_yaml
      queue_status.push(status)

  		if busy
  			self.last_busy_send = now
  		else
  			self.last_idle_send = now
  		end
  	end
  	self.last_time = Time.now
  end
end
