provider "aws" {
  #version = "~> 3.0"
  region  = "us-east-1"
}

# MACHINES

## NOMAD-CONSUL-VAULT-FABIO
resource "aws_instance" "machine_provision_1"{}

resource "aws_instance" "machine_provision_2"{}

## PROMETHEUS-GRAFANA

resource "aws_instance" "machine_monitor"{}

## WORKERS (NOMAD_CLIENT + {APACHE OFBIZ, POSTGRESS} )

resource "aws_instance" "machine_worker_1"{}

resource "aws_instance" "machine_worker_2"{}

# LAMBDAS

## GRAPHQL ##
resource "aws_lambda_function" "handler"{}

resource "aws_lambda_function" "schema"{}

resource "aws_lambda_function" "resolver"{}

## MAIL NOTIFY ##

resource "aws_lambda_function" "sender"{}

## WEBSITE ##

resource "aws_lambda_function" "builder"{}

## DB INTERACTION ##

resource "aws_lambda_function" "get"{}

resource "aws_lambda_function" "post"{}

resource "aws_lambda_function" "put"{}

resource "aws_lambda_function" "delete"{}


# SES - Simple Email Service

# DynamoDB

# API Endpoint

resource "aws_api_gateway_rest_api" "graphQl_intake" {}
