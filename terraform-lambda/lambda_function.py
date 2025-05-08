def lambda_handler(event, context):
    return {
        "statusCode": 200,
        "body": "Hello from Lambda!"
    }
#after create this lambda_function file, run the following command to create a zip file
# zip -r lambda_function.zip lambda_function.py