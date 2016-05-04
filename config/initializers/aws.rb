require 'aws-sdk'
Aws.config.update(
    {
        region: "us-east-1",
        credentials: Aws::Credentials.new('AKIAI6MNVPDMEWKISAAQ', 'arPQU1cxo9jXwvycvHzhXTJqaa3b4Kjkh4mLCY3I'), # it's a secret ;-)
        endpoint: "http://localhost:8000" #'us-east-1.amazonaws.com'
    });
