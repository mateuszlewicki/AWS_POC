from http import HTTPStatus
import boto3, json, psycopg2, datetime

# ADD VALUES

def lambda_handler(event, context):
    return checkSystem(event["system"])=="MTT"?noSQL(event):useSQL(event)

def checkSystem(invokedSystem):
    return invokedSystem=="MTT"?"MTT":"Legacy"

def noSQL(event):
    dynamodb = boto3.resource('dynamodb', region_name='TODO', endpoint_url="TODO")
    table = dynamodb.Table('packages')

    try:
        response = table.put_item(
            Item={
               # 'package_id': event['package_id'] event['date']?event['date']:datetime.datetime.now().strftime("%d/%m/%Y %H:%M:%S UTC+01:00")
               'date_send':event['date_send']?event['date_send']:datetime.datetime.now().strftime("%d/%m/%Y %H:%M:%S UTC+01:00"),
               'from':event['from'],
               'to':event['to'],
               'delivery_updates' : {
                   'date': event['date_send'],
                   'post_office': event['post_office']?event['post_office']:event['from'],
                   'message': "Package registered"
               }
            }
        )
    except: ClientError as e:
         print(e.response['Error']['Message'])
    else:
        item = response['Item']
        print("PutItem succeeded:")
        return(HTTPStatus.CREATED.value)


def SQL(event):
    #TODO
    
