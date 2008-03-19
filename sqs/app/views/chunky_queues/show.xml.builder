xml.GetQueueAttributesResponse do
  xml.AttributedValue do
    xml.Attribute "ApproximateNumberOfMessages"
    xml.Value @chunky_queue.messages.size
  end

  xml.AttributedValue do
    xml.Attribute "VisibilityTimeout"
    xml.Value @chunky_queue.visibility_timeout
  end

  xml.ResponseStatus do
    xml.StatusCode "Success"
  end
end

