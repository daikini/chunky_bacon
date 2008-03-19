xml.CreateQueueResponse "xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance", "xsi:type" => "CreateQueueResponse", "xmlns" => "http://queue.amazonaws.com/doc/2007-05-01/" do
  xml.QueueUrl full_url(:chunky_queue, @chunky_queue)
  xml.ResponseStatus do
    xml.StatusCode "Success"
  end
end