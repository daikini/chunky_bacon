class CartoonFox
  def self.get_packaged_bacon!
    packaged = SQS.queue("chunky-packaged")
    
    loop do
      if( message = packaged.receive) && (slice = Slice[message.body.to_i])
        slice.set(:packaged_at => Time.now)
        message.delete
      end
      
      sleep 0.5
    end
  end
  
  def self.supervise!
    require Merb.root/"vendor"/"kato"/"lib"/"kato"
    pool_supervisor = Kato::PoolSupervisor.new(KATO_CONFIG)
    pool_supervisor.run
  end
end
