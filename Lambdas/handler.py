from http import HTTPStatus
import graphene 
from graphql import GraphQLError
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

def graphqlHandler(eventRequestBody, context = {}):

  try:
    requestBody = json.loads(eventRequestBody)
  except:
    requestBody = {}
  query = ''
  variables = {}
  if ('query' in requestBody):
    query = requestBody['query']
  if ('variables' in requestBody):
    variables = requestBody['variables']
    # schema = Schema(query=Query)

  executionResult = schema.execute(query=Query, variables=variables)

  responseBody = {
    "data": dict(executionResult.data) if executionResult.data != None else None,
  }
  if (executionResult.errors != None):
    responseBody['errors'] = []
    for error in executionResult.errors:
      responseBody['errors'].append(str(error))
  return responseBody

def lambda_handler(event, context):
  httpMethod = event.get('httpMethod')
  if (httpMethod == 'OPTIONS'):
    return {
      'statusCode': 200,
      'headers': responseHeaders,
      'body': ''
    }
  requestBody = event.get('body')
  responseBody = graphqlHandler(requestBody, context)
  return {
    'statusCode': 200,
    'headers': responseHeaders,
    'body': json.dumps(responseBody)
  }
