xml.SendMessageResponse do
  xml.MessageId @chunky_message.id
  xml.ResponseStatus do
    xml.StatusCode "Success"
  end
end