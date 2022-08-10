import boto3
import json

def lambda_handler(event, context):

    AccountNumber = event['params']['querystring']['AccountNumber']
    sts_client = boto3.client('sts')
    sts_session = sts_client.assume_role(RoleArn='arn:aws:iam::'+AccountNumber+':role/ECSReset', RoleSessionName='ECS-session')


    KEY_ID = sts_session['Credentials']['AccessKeyId']
    ACCESS_KEY = sts_session['Credentials']['SecretAccessKey']
    TOKEN = sts_session['Credentials']['SessionToken']
    
    ecs_client = boto3.client('ecs', region_name='us-east-1', aws_access_key_id=KEY_ID, aws_secret_access_key=ACCESS_KEY, aws_session_token=TOKEN)

    paginator = ecs_client.get_paginator('list_clusters')
    response_iterator = paginator.paginate(
        PaginationConfig={
            'PageSize': 100,
        }
    )
    for i in response_iterator:
        return json.dumps(i, indent=4, default=str)