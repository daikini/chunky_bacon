xml.ReceiveMessageResponse do
  @chunky_messages.each do |chunky_message|
    xml.Message do
      xml.MessageId chunky_message.id
      xml.MessageBody chunky_message.body
    end
  end

  xml.ResponseStatus do
    xml.StatusCode "Success"
  end
end