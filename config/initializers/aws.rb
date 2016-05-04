require 'aws-sdk'
Aws.config.update(
    {
        region: "us-east-1",
        credentials: '', # it's a secret ;-)
        endpoint: "http://localhost:8000" #'us-east-1.amazonaws.com'
    });
