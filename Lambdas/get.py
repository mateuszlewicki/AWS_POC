import boto3, json
def lambda_handler(event, context):
    checkSystem(event["system"])=="MTT"?noSQL(event):useSQL(event)

def checkSystem(invokedSystem):
    return invokedSystem=="MTT"?"MTT":"Legacy"

def noSQL(event):

def SQL(event):
    
