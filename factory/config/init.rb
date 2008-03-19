# Make the app"s "gems" directory a place where gems are loaded from
Gem.clear_paths
Gem.path.unshift(Merb.root / "gems")

# Make the app"s "lib" directory a place where ruby files get "require"d from
$LOAD_PATH.unshift(Merb.root / "lib")


Merb::Config.use do |c|
  c[:session_store] = "none"
  # c[:adapter] = "thin" if c[:adapter] == "mongrel"
end  

### Merb doesn"t come with database support by default.  You need
### an ORM plugin.  Install one, and uncomment one of the following lines,
### if you need a database.

### Uncomment for DataMapper ORM
# use_orm :datamapper

### Uncomment for ActiveRecord ORM
# use_orm :activerecord

### Uncomment for Sequel ORM
use_orm :sequel


### This defines which test framework the generators will use
### rspec is turned on by default
# use_test :test_unit
# use_test :rspec

### Add your other dependencies here

# These are some examples of how you might specify dependencies.
# 
# dependencies "RedCloth", "merb_helpers"
# OR
# dependency "RedCloth", "> 3.0"
# OR
# dependencies "RedCloth" => "> 3.0", "ruby-aes-cext" => "= 1.0"

require 'right_aws'
require 'right_aws_sqs_ex'
RightAws::RightAWSParser.xml_lib = "libxml"
AWS_CONFIG = Erubis.load_yaml_file(Merb.root/"config"/"aws.yml")[Merb.environment.to_sym]
SQS = RightAws::Sqs.new(AWS_CONFIG[:access_id], AWS_CONFIG[:access_key], :server => AWS_CONFIG[:sqs][:host], :port => (AWS_CONFIG[:sqs][:port]), :protocol => AWS_CONFIG[:sqs][:protocol])
EC2 = RightAws::Ec2.new(AWS_CONFIG[:access_id], AWS_CONFIG[:access_key], :server => AWS_CONFIG[:ec2][:host], :port => (AWS_CONFIG[:ec2][:port]), :protocol => AWS_CONFIG[:ec2][:protocol])

KATO_CONFIG = Erubis.load_yaml_file(Merb.root/"config"/"kato.yml")[Merb.environment.to_sym]

Merb::BootLoader.after_app_loads do
  ### Add dependencies here that must load after the application loads:
  
  # dependency "magic_admin" # this gem uses the app"s model classes
end
