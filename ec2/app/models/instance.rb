class Instance < Sequel::Model
  STATE = { 0 => "pending", 16 => "running", 32 => "shutting-down", 48 => "terminated" }
  
  set_schema do
    primary_key :id
    varchar :image_identifier
    varchar :key_name
    text :user_data
    integer :state
    integer :launch_index
    datetime :created_at
    integer :pid
  end
  
  after_initialize do
    self.state = 16 if state.blank?
  end
  
  before_create do
    self.created_at = Time.now
  end
  
  after_create do
     config = <<-GOD_CONFIG
     God.watch do |w|
       w.group = "ec2-instances"
       w.name = w.group + "-#{id}"
       w.log = "#{Merb.root}/log/ec2-instances-#{id}.log"
  
       w.interval = 30.seconds
  
       w.start = "/usr/bin/ruby '#{Merb.root}/ami/#{image_identifier}.rb' #{id}"
       w.start_grace = 10.seconds
  
       w.start_if do |start|
         start.condition(:process_running) do |c|
           c.interval = 5.seconds
           c.running = false
         end
       end
  
       w.restart_if do |restart|
         restart.condition(:memory_usage) do |c|
           c.above = 150.megabytes
           c.times = [3,5] # 3 out of 5 intervals
         end
  
         restart.condition(:cpu_usage) do |c|
           c.above = 50.percent
           c.times = 5
         end
       end
  
       w.lifecycle do |on|
         on.condition(:flapping) do |c|
           c.to_state = [:start, :restart]
           c.times = 5
           c.within = 5.minutes
           c.transition = :unmonitored
           c.retry_in = 10.minutes
           c.retry_times = 5
           c.retry_within = 2.hours
         end
       end
     end
    GOD_CONFIG
    
    
    File.open(god_config_path, "w") { |file| file.puts config }
    system "god" # Are you there? It's me, EC2.
    system "god load #{god_config_path}"
  end
  
  def terminate
    set(:state => 48)
    system "god stop ec2-instances-#{id}"
    system "god remove ec2-instances-#{id}"
    File.delete god_config_path
  end
  
  private
    def god_config_path
      Merb.root/"log"/"#{id}.god"
    end
end

Instance.create_table!
