class CartoonFoxes < Application
  only_provides :js
  
  def index
    @cartoon_foxes = EC2.describe_instances.find_all { |fox| %w[pending running].include?(fox[:aws_state]) }
    render
  end
  
end
