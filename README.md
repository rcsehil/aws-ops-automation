# AWS Ops automation

A lambda function to start, stop or resize an EC2 instance. 
I am triggering the function with time based CloudWatch rules to downsize or upsize instances at certain times. 

## Development

Build the docker image. You only need to do it once.

		docker build . -t ops-automation

On OSX:

		# On the host shell
		. .dev_aliases
		dsh

On Ubuntu:

		# On the host shell
		. .dev_aliases
		sdsh

Edit the code, then go to the terminal and do
		
		AWS_PROFILE=YOUR_PROFILE_NAME ruby instance_manager.rb

Running specs

    spec

## Configuring the lambda function

Resize event:

		{
			"instance_type": "t3.small", 
			"instance_id": "i-12345", 
			"action": "resize"
		}

Start event:

    {
      "instance_id": "i-12345", 
      "action": "start"
    }

Stop event:

    {
      "instance_id": "i-12345", 
      "action": "stop"
    }

## CloudWatch cron example

From monday to friday at 18:00 GMT

    00 18 ? * MON-FRI *

## TODO

- Create a CloudFormation template for the Lambda function and an IAM role for the function to access EC2 resources.
