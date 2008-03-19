class Instances < Application
  only_provides :xml
  
  def index
    @instances = Instance.all
    display @instances
  end

  def create
    @instances = (0...params[:MaxCount].to_i).collect do |launch_index|
      Instance.create :image_identifier => params[:ImageId], :key_name => params[:KeyName], :user_data => params[:UserData], :launch_index => launch_index
    end
    render
  end

  def destroy
    instance_ids = params.collect { |k,v| params[k] if k =~ /InstanceId\.\d+/ }.compact
    @instances = Instance.filter(:id => instance_ids)
    render
  end
  
end
