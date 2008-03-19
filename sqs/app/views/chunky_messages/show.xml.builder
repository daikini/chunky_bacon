xml.PeekMessageResponse do
  xml.Message do
    xml.MessageId @chunky_message.id
    xml.MessageBody @chunky_message.body
  end

  xml.ResponseStatus do
    xml.StatusCode "Success"
  end
end