xml.DescribeInstancesResponse "xmlns" => "http://ec2.amazonaws.com/doc/2007-08-29" do
  xml.reservationSet do
    xml.item do
      xml.reservationId "r-44a5402d"
      xml.ownerId "UYY3TLBUXIEON5NQVUUX6OMPWBZIQNFM"
      xml.groupSet do
        xml.item do
          xml.groupId "default"
        end
      end

      xml.instancesSet do
        xml << partial(:instance, :with => @instances)
      end
    end
  end
end
