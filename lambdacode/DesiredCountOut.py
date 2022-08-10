import boto3
import json
import os
import time

def lambda_handler(event, context): 
    AccountNumber = event['params']['querystring']['AccountNumber']
    ClusterName = event['params']['querystring']['ClusterName']
    ServiceName = event['params']['querystring']['ServiceName']

    sts_client = boto3.client('sts')
    sts_session = sts_client.assume_role(RoleArn='arn:aws:iam::'+AccountNumber+':role/ECSReset', RoleSessionName='ECS-session')


    KEY_ID = sts_session['Credentials']['AccessKeyId']
    ACCESS_KEY = sts_session['Credentials']['SecretAccessKey']
    TOKEN = sts_session['Credentials']['SessionToken']

    ecs_client = boto3.client('ecs', region_name='us-east-1', aws_access_key_id=KEY_ID, aws_secret_access_key=ACCESS_KEY, aws_session_token=TOKEN)


    oldDesiredCount = os.getenv('OldDCount')

    ecs_client.update_service(
        cluster = ClusterName,
        service = ServiceName,
        desiredCount = oldDesiredCount
    )

    time.sleep(15)

    return {
        'statuscode' : 200,
        'body' : 'Desired Count changed to {oldDesiredCount}, wait until the containers status be RUNNING'
    }