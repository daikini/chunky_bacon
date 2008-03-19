xml.item do
  xml.instanceId instance.id
  xml.imageId instance.image_identifier
  xml.instanceState do
    xml.code instance.state
    xml.name Instance::STATE[instance.state]
  end

  xml.privateDnsName "privateDnsName"
  xml.dnsName "dnsName"
  xml.keyName instance.key_name
  xml.productCodesSet do
    xml.item do
      xml.productCode "productCode"
    end
  end
  
  xml.amiLaunchIndex instance.launch_index
  xml.InstanceType "m1.small"
  xml.launchTime instance.created_at
end
