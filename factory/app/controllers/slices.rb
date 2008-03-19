class Slices < Application
  only_provides :json

  def index
    @slices = Slice.unconveyed(params[:limit])
    display @slices
  end
  
  def show
    @slice = Slice[params[:id]]
    display @slice
  end
  
  def create
    @slice = Slice.create
    display @slice
  end
  
end
