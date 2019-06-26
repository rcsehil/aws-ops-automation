require 'json'
require 'aws-sdk-ec2'

RESIZE = 'resize'
START = 'start'
STOP = 'stop'
RUNNING = 'running'

def lambda_handler(event:, context:)
  ec2 = Aws::EC2::Resource.new
  instance = ec2.instance(event['instance_id'])
  puts "Found instance: #{event['instance_id']}."
  action = event['action']
  if action == RESIZE
    resize(instance, event['instance_type'])
  elsif action == START
    start(instance)
  elsif action == STOP
    stop(instance)
  else
    puts "Unknown action: #{action}"
    puts 'Not doing anything.'
  end 
  { result: instance.state.name }
end

def resize(instance, instance_type)
  if instance.instance_type == instance_type
    puts 'Instance type is not changing, not doing anything.'
    return
  end
  stop(instance) if instance.state.name == RUNNING
  puts "Setting instance type to #{instance_type}."
  instance.modify_attribute(instance_type: Aws::EC2::Types::AttributeValue.new(value: instance_type))
  start(instance)
  puts "State: #{instance.state}."
end

def start(instance)
  puts 'Starting instance.'
  instance.start
  instance.wait_until_running
  puts 'Started instance.'
end

def stop(instance)
  puts 'Stopping instance.'
  instance.stop
  instance.wait_until_stopped
  puts 'Stopped instance.'
end
