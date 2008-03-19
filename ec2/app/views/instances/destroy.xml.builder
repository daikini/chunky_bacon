xml.TerminateInstancesResponse "xmlns" => "http://ec2.amazonaws.com/doc/2007-08-29" do
  xml.instancesSet do
    @instances.each do |instance|
      xml.item do
        xml.instanceId instance.id
        xml.shutdownState do
          xml.code "32"
          xml.name "shutting-down"
        end

        xml.previousState do
          xml.code "16"
          xml.name "running"
        end
      end
      instance.terminate
    end
  end
end
