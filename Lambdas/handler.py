from http import HTTPStatus
from graphene import ObjectType, String, Schema
import boto3, json, psycopg2

class Query(ObjectType):
    # this defines a Field `hello` in our Schema with a single Argument `name`
    action = String(action=String(default_value="GET"))
    data = String(data=String(default_value=""))
    # our Resolver method takes the GraphQL context (root, info) as well as
    # Argument (name) for the Field and returns data for the query Response
    def resolve_action(root, info, action):
        client = boto3.client('lambda')
        functions = {
            GET : "aws_poc_get"
            POST : "aws_poc_post"
            PUT : "aws_poc_put"
            DELETE : "aws_poc_del"
        }
        return client.invoke(
            FunctionName=functions.get(action.upper(),"nothing"),
            InvocationType='RequestResponse',
            LogType='None',
            Payload=self.data
        )

schema = Schema(query=Query)
