#!/usr/bin/env ruby
$:.push File.join(File.dirname(__FILE__), '..', 'lib')
require 'rubygems'
require 'right_aws'
require 'right_aws_sqs_ex'
require 'abstract_service'

$packing = true
Signal.trap("TERM") { $packing = false }

AWS_CONFIG = {
  :access_id => "access_id",
  :access_key => "access_key",
  :sqs => {
    :host => "megiddo.local",
    :port => 11300,
    :protocol => "http"
  }
}

class CartoonFox < AbstractService
  attr_accessor :unpackaged, :queue_status, :packaged
  def initialize(instance_id)
    super(instance_id)
    sqs = RightAws::Sqs.new(AWS_CONFIG[:access_id], AWS_CONFIG[:access_key], :server => AWS_CONFIG[:sqs][:host], :port => (AWS_CONFIG[:sqs][:port]), :protocol => AWS_CONFIG[:sqs][:protocol])
    @unpackaged = sqs.queue("chunky-unpackaged")
    @queue_status = sqs.queue("chunky-unpackaged-status")
    @packaged = sqs.queue("chunky-packaged")
  end
  
  def start_packing!
    while $packing
      if message = unpackaged.receive
        send_status_update(true)
        packaged.push message.body
        message.delete
        send_status_update(false)
      end

      sleep 2
    end
  end
end

cartoon_fox = CartoonFox.new(ARGV.first)
cartoon_fox.start_packing!
