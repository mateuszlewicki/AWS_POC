from http import HTTPStatus
import boto3, json, psycopg2

# GET VALUES

def lambda_handler(event, context):
    return checkSystem(event["system"])=="MTT"?noSQL(event):useSQL(event)

def checkSystem(invokedSystem):
    return invokedSystem=="MTT"?"MTT":"Legacy"

def noSQL(event):
    dynamodb = boto3.resource('dynamodb', region_name='TODO', endpoint_url="TODO")
    table = dynamodb.Table('packages')

    try:
        response = table.get_item(
            Key={
                'package_id': event['package_id']
                }
            )
    except: ClientError as e:
         print(e.response['Error']['Message'])
         return(HTTPStatus.NOT_FOUND.value)
    else:
        item = response['Item']
        print("GetItem succeeded:")
        return(item)


def SQL(event):
    #TODO
    
