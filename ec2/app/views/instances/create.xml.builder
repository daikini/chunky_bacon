xml.RunInstancesResponse "xmlns" => "http://ec2.amazonaws.com/doc/2007-08-29" do
  xml.reservationId "r-47a5402e"
  xml.ownerId "495219933132"
  xml.groupSet do
    xml.item do
      xml.groupId "default"
    end
  end
  
  xml.instancesSet do
    xml << partial(:instance, :with => @instances)
  end
end
