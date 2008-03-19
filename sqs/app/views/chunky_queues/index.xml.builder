xml.ListQueuesResponse "xmlns" => "http://queue.amazonaws.com/doc/2007-05-01/", "xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance", "xsi:type" => "ListQueuesResponse" do
  xml.Queues do
    @chunky_queues.each do |chunky_queue|
      xml.QueueUrl full_url(:chunky_queue, chunky_queue)
    end
  end
  
  xml.ResponseStatus do
    xml.StatusCode "Success"
  end
end