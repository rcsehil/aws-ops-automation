require_relative '../instance_manager'
require 'rspec'

describe 'lambda_handler' do
  let(:instance) { instance = instance_double(Aws::EC2::Instance) }
	let(:ec2) do
		ec2 = instance_double(Aws::EC2::Resource)
		allow(ec2).to receive(:instance).and_return(instance)
		ec2
	end

  before(:each) do
    expect(Aws::EC2::Resource).to receive(:new).and_return(ec2)
    allow(instance).to receive(:state).and_return(double(name: 'running'))
  end

	it 'starts an instance' do
    event = {
      'instance_id' => 'i-1234',
      'action' => START
    }
    expect(instance).to receive(:start)
    expect(instance).to receive(:wait_until_running)
		lambda_handler(event: event, context: {})
	end

  it 'stops an instance' do
    event = {
      'instance_id' => 'i-1234',
      'action' => STOP
    }
    expect(instance).to receive(:stop)
    expect(instance).to receive(:wait_until_stopped)
    lambda_handler(event: event, context: {})
  end

  it 'resizes an instance' do
    event = {
      'instance_type' => 't3.small',
      'instance_id' => 'i-1234',
      'action' => RESIZE
    }
    expect(instance).to receive(:stop)
    expect(instance).to receive(:wait_until_stopped)
    expect(instance).to receive(:instance_type).twice.and_return('t2.small')
    expect(instance).to receive(:instance_type).and_return('t3.small')
    expect(instance).to receive(:modify_attribute)
    allow(instance).to receive(:instance_id)
    expect(instance).to receive(:start)
    expect(instance).to receive(:wait_until_running)
    lambda_handler(event: event, context: {})
  end
end
