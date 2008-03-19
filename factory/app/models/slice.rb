class Slice < Sequel::Model
  set_schema do
    primary_key :id
    datetime :queued_at
    datetime :packaged_at
    integer :shape
    datetime :conveyed_at
    
    index [:conveyed_at, :packaged_at]
  end
  
  after_initialize do
    self.shape = rand(3).next if shape.blank?
  end
  
  def self.package!
    slice = create(:queued_at => Time.now)
    queue = SQS.queue("chunky-unpackaged")
    queue.push(slice.id)
    slice
  end
  
  def to_json
    image = packaged? ? "packaged_bacon" : "bacon#{shape}"
    {:id => id, :image_url => "/images/#{image}.png", :packaged => packaged?}.to_json
  end
  
  def packaged?
    !packaged_at.blank?
  end
  
  def self.unconveyed(number_of_slices = 1)
    conveyed_at = Time.now
    unconvyed_slices = filter(:conveyed_at => nil, :packaged_at => nil).order(:id).limit(number_of_slices).all
    unconvyed_slices.each { |slice| slice.set(:conveyed_at => conveyed_at) }
    unconvyed_slices
  end
end
Slice.create_table unless Slice.table_exists?
