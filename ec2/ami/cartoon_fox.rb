#!/usr/bin/env ruby
$:.push File.join(File.dirname(__FILE__), '..', 'lib')
require 'rubygems'
require 'right_aws'
require 'right_aws_sqs_ex'

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

class CartoonFox
  MIN_STATUS_INTERVAL = 2
  
  attr_accessor :instance_id, :unpackaged, :unpackaged_status, :packaged, :last_busy_send, :last_idle_send, :last_time
  def initialize(instance_id)
    @instance_id = instance_id
    sqs = RightAws::Sqs.new(AWS_CONFIG[:access_id], AWS_CONFIG[:access_key], :server => AWS_CONFIG[:sqs][:host], :port => (AWS_CONFIG[:sqs][:port]), :protocol => AWS_CONFIG[:sqs][:protocol])
    @unpackaged = sqs.queue("chunky-unpackaged")
    @unpackaged_status = sqs.queue("chunky-unpackaged-status")
    @packaged = sqs.queue("chunky-packaged")
    @last_time = (Time.now - MIN_STATUS_INTERVAL - 1)
    @last_busy_send = @last_time
    @last_idle_send = @last_time
  end
  
  def send_status_update(busy)
    now = Time.now
    if (busy && (now - last_busy_send) > MIN_STATUS_INTERVAL) ||
  		(!busy && (now - last_idle_send) > MIN_STATUS_INTERVAL)

  		interval = now - last_time
  		status = {:instance_id => instance_id, :last_interval => interval, :state => (busy ? "busy" : "idle")}.to_yaml
      unpackaged_status.push(status)

  		if busy
  			self.last_busy_send = now
  		else
  			self.last_idle_send = now
  		end
  	end
  	self.last_time = Time.now
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
