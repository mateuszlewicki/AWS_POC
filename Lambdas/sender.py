from http import HTTPStatus
import boto3, json, psycopg2

def lambda_handler(event, context):
    # return checkSystem(event["system"])=="MTT"?noSQL_MTT(event):noSQL_Website(event)
    client = boto3.client('ses')
    response = client.send_email(
        Source='string',
        Destination={
            'ToAddresses': [
                'mateusz.lewicki@atos.net',
            ]
        },
        Message={
            'Subject': {
                'Data': 'New Package to you',
                'Charset': 'UTF-8'
            },
            'Body': {
                'Text': {
                    'Data': "New package was sent to you \n Package number: "+str(event['pkgnum']),
                    'Charset': 'UTF-8'
                }
            }
        },
        ReplyToAddresses=[
            'mateusz.lewicki@windowslive.com',
        ],
    )
