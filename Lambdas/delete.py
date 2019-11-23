from http import HTTPStatus
import boto3, json, psycopg2

# DELETE VALUES

def lambda_handler(event, context):
    return checkSystem(event["system"])=="MTT"?noSQL(event):useSQL(event)

def checkSystem(invokedSystem):
    return invokedSystem=="MTT"?"MTT":"Legacy"

def noSQL(event):
    dynamodb = boto3.resource('dynamodb', region_name='TODO', endpoint_url="TODO")
    table = dynamodb.Table('packages')

    try:
        response = table.delete_item(
            Key={
                'package_id': event['package_id']
                }
            )


    except ClientError as e:
    if e.response['Error']['Code'] == "ConditionalCheckFailedException":
        print(e.response['Error']['Message'])
    else:
        raise
    else:
    print("DeleteItem succeeded:")
    return return(HTTPStatus.OK.value)

def SQL(event):
    #TODO
    
