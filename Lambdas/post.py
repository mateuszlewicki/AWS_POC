from http import HTTPStatus
import boto3, json, psycopg2, datetime

# UPDATE VALUES

def lambda_handler(event, context):
    return checkSystem(event["system"])=="MTT"?noSQL_MTT(event):noSQL_Website(event)

def checkSystem(invokedSystem):
    return invokedSystem=="MTT"?"MTT":"Legacy"

def noSQL_MTT(event):
    dynamodb = boto3.resource('dynamodb', region_name='TODO', endpoint_url="TODO")
    table = dynamodb.Table('packages')

    try:
        response = table.update_item(
            Key={
                'package_id': event['package_id']
            },
            UpdateExpression="set #du = list_append(#du, :vals)",
            ExpressionAttributeValues={
                '#du' : 'delivery_updates',
                ':vals' : {
                     'date': event['date']?event['date']:datetime.datetime.now().strftime("%d/%m/%Y %H:%M:%S UTC+01:00"),
                   'post_office': event['post_office']?event['post_office']:"next office",
                   'message': event['message']?event['message']:"Package Update"
                }
            },
            RetrunValues="UPDATED_NEW"
        )
    except: ClientError as e:
        print(e.response['Error']['Message'])
        return(HTTPStatus.NOT_MODIFIED.value)
        
    else:
        print("UpdateItem succeeded:")
        return(HTTPStatus.OK.value)


def noSQL_Website(event):
    #TODO
    
