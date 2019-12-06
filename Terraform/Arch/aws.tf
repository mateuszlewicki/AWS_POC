terraform{
  backend "s3" {
    bucket = "mlewicki-mybucket-atos.net"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}

variable "my-access-key" {}
variable "my-secret-key" {}


# Specify the provider and access details
provider "aws" {
  #version = "~> 3.0"
  region  = "us-east-1"
  access_key = var.my-access-key
  secret_key = var.my-secret-key
}




# Create a VPC to launch our instances into
resource "aws_vpc" "default" {
  cidr_block = "10.0.0.0/16"
}

# Create an internet gateway to give our subnet access to the outside world
resource "aws_internet_gateway" "default" {
  vpc_id = "${aws_vpc.default.id}"
}

# Grant the VPC internet access on its main route table
resource "aws_route" "internet_access" {
  route_table_id         = "${aws_vpc.default.main_route_table_id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.default.id}"
}

# Create a subnet to launch our instances into
resource "aws_subnet" "default" {
  vpc_id                  = "${aws_vpc.default.id}"
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
}

# A security group for the ELB so it is accessible via the web
resource "aws_security_group" "elb" {
  name        = "mateusz-lewicki-awspoc-elb"
  description = "Used in the terraform"
  vpc_id      = "${aws_vpc.default.id}"

  # HTTP access from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # fabio admin access from anywhere
  ingress {
    from_port   = 9998
    to_port     = 9998
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# default security group to access
# the instances over SSH and HTTP
resource "aws_security_group" "default" {
  name        = "poc"
  description = "Used in the terraform"
  vpc_id      = "${aws_vpc.default.id}"

  # SSH access from anywhere
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTP access from the VPC
  ingress {
    from_port   = 9999
    to_port     = 9999
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  ingress {
    from_port   = 8300
    to_port     = 8302
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

    ingress{
    from_port   = 8400
    to_port     = 8400
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }
    ingress{
    from_port   = 8500
    to_port     = 8500
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }
    ingress{
    from_port   = 8600
    to_port     = 8600
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
    ingress{
    from_port   = 8300
    to_port     = 8302
    protocol    = "udp"
  }
    ingress{
    from_port   = 8600
    to_port     = 8600
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  #########
  egress {
    from_port   = 8300
    to_port     = 8302
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

    egress{
    from_port   = 8400
    to_port     = 8400
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }
    egress{
    from_port   = 8500
    to_port     = 8500
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }
    egress{
    from_port   = 8600
    to_port     = 8600
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
    egress{
    from_port   = 8300
    to_port     = 8302
    protocol    = "udp"
  }
    egress{
    from_port   = 8600
    to_port     = 8600
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # HTTP access from the VPC
  ingress {
    from_port   = 9998
    to_port     = 9998
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_elb" "poc_web" {
  name = "head-over-to-fabio"

  subnets         = ["${aws_subnet.default.id}"]
  security_groups = ["${aws_security_group.elb.id}"]
  instances       = ["${aws_instance.machine_provision_1.id}","${aws_instance.machine_provision_2.id}","${aws_instance.machine_provision_3.id}"]

  listener {
    instance_port     = 9999
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  listener {
    instance_port     = 9998
    instance_protocol = "http"
    lb_port           = 9998
    lb_protocol       = "http"
  }

}

resource "aws_proxy_protocol_policy" "ProxyProtocol" {
  load_balancer = "${aws_elb.poc_web.name}"
  instance_ports = ["9999"]
}
# MACHINES

resource "aws_iam_role" "ec2_role" {
  name = "ec2_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ec2_profile"
  role = "${aws_iam_role.ec2_role.name}"
}

resource "aws_iam_role_policy" "ec2_policy" {
  name = "ec2_policy"
  role = "${aws_iam_role.ec2_role.id}"

  policy = <<EOF
 {
 "Version": "2012-10-17",
 "Statement": [
     {
     "Sid": "ec2",
     "Effect": "Allow",
     "Action": "ec2:*",
     "Resource": "*"
     }
 ]
 }
EOF
}

data "aws_ami" "provision_ami" {
  most_recent      = true
  name_regex       = "^Provision-cluster-*"
  owners           = ["984287815837"]
}

data "aws_ami" "worker_ami" {
  // executable_users = ["self"]
  most_recent      = true
  name_regex       = "^Nomad-worker-*"
  owners           = ["984287815837"]
}

## NOMAD-CONSUL-VAULT-FABIO
resource "aws_instance" "machine_provision_1"{
 
 

  instance_type = "t2.micro"
  iam_instance_profile = "${aws_iam_instance_profile.ec2_profile.name}"


  ami = "${data.aws_ami.provision_ami.id}"

  //key_name = "${aws_key_pair.auth.id}"

  vpc_security_group_ids = ["${aws_security_group.default.id}"]

  subnet_id = "${aws_subnet.default.id}"

  tags = {
    Name = "machine_provision_1"
    Type = "Quorum"
  }
  user_data ="${file("boot.sh")}"
  
  
}

resource "aws_instance" "machine_provision_2"{

  instance_type = "t2.micro"
iam_instance_profile = "${aws_iam_instance_profile.ec2_profile.name}"
  ami = "${data.aws_ami.provision_ami.id}"

  vpc_security_group_ids = ["${aws_security_group.default.id}"]

  subnet_id = "${aws_subnet.default.id}"

  tags = {
    Name = "machine_provision_2"
    Type = "Quorum"
  }
}

resource "aws_instance" "machine_provision_3"{

  /* connection {
    user = "ec2-user"
  }*/

  instance_type = "t2.micro"
iam_instance_profile = "${aws_iam_instance_profile.ec2_profile.name}"
  ami = "${data.aws_ami.provision_ami.id}"

  //key_name = "${aws_key_pair.auth.id}"

  vpc_security_group_ids = ["${aws_security_group.default.id}"]

  subnet_id = "${aws_subnet.default.id}"

  tags = {
    Name = "machine_provision_3"
    Type = "Quorum"
  }
}




## WORKERS (NOMAD_CLIENT + {APACHE OFBIZ, POSTGRESS} / PROMETHEUS-GRAFANA )

resource "aws_instance" "machine_worker_1"{

/* connection {
    user = "ec2-user"
  }*/

  instance_type = "t2.micro"

  ami = "${data.aws_ami.worker_ami.id}"
iam_instance_profile = "${aws_iam_instance_profile.ec2_profile.name}"
  //key_name = "${aws_key_pair.auth.id}"

  vpc_security_group_ids = ["${aws_security_group.default.id}"]

  subnet_id = "${aws_subnet.default.id}"
  tags = {
    Name = "machine_worker_1"
    }
}

resource "aws_instance" "machine_worker_2"{

/* connection {
    user = "ec2-user"
  }*/

  instance_type = "t2.micro"
iam_instance_profile = "${aws_iam_instance_profile.ec2_profile.name}"
  ami = "${data.aws_ami.worker_ami.id}"

  //key_name = "${aws_key_pair.auth.id}"

  vpc_security_group_ids = ["${aws_security_group.default.id}"]

  subnet_id = "${aws_subnet.default.id}"
  tags = {
    Name = "machine_worker_2"
    }
}

resource "aws_instance" "machine_worker_3"{

/* connection {
    user = "ec2-user"
  }*/

  instance_type = "t2.micro"
iam_instance_profile = "${aws_iam_instance_profile.ec2_profile.name}"
  ami = "${data.aws_ami.worker_ami.id}"

  //key_name = "${aws_key_pair.auth.id}"

  vpc_security_group_ids = ["${aws_security_group.default.id}"]

  subnet_id = "${aws_subnet.default.id}"
  tags = {
    Name = "machine_worker_3"
    }
}

# LAMBDAS
resource "aws_iam_role" "lambda_all" {
  name = "lambda_all"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}
 resource "aws_iam_policy" "lambda_all" {
   policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "fTerra",
            "Effect": "Allow",
            "Action": "lambda:*",
            "Resource": "*"
        }
    ]
}
 POLICY
 }
## GRAPHQL ##
resource "aws_lambda_function" "handler"{
  s3_bucket= "mlewicki-mybucket-atos.net"
  s3_key = "handler.zip"
  function_name="aws_poc_handler"
  role="${aws_iam_role.lambda_all.arn}"
  handler="handler.lambda_handler"
  runtime= "python3.8"
}

## MAIL NOTIFY ##

//resource "aws_lambda_function" "sender"{}


## DB INTERACTION ##

resource "aws_lambda_function" "get"{
  s3_bucket= "mlewicki-mybucket-atos.net"
  s3_key = "get.zip"
  function_name="aws_poc_get"
  role="${aws_iam_role.lambda_all.arn}"
  handler="get.lambda_handler"
  runtime= "python3.8"
}

resource "aws_lambda_function" "post"{
  s3_bucket= "mlewicki-mybucket-atos.net"
  s3_key = "post.zip"
  function_name="aws_poc_post"
  role="${aws_iam_role.lambda_all.arn}"
  handler="post.lambda_handler"
  runtime= "python3.8"
}

resource "aws_lambda_function" "put"{
  s3_bucket= "mlewicki-mybucket-atos.net"
  s3_key = "put.zip"
  function_name="aws_poc_put"
  role="${aws_iam_role.lambda_all.arn}"
  handler="put.lambda_handler"
  runtime= "python3.8"
}

resource "aws_lambda_function" "delete"{
  s3_bucket= "mlewicki-mybucket-atos.net"
  s3_key = "delete.zip"
  function_name="aws_poc_del"
  role="${aws_iam_role.lambda_all.arn}"
  handler="delete.lambda_handler"
  runtime= "python3.8"
}


# SES - Simple Email Service

# DynamoDB

// resource "aws_dynamodb_table" "MTT-table" {
//   name           = "MTT"
//   read_capacity  = 20
//   write_capacity = 20
//   hash_key       = "package_id"
//   range_key      = "date_send"

// attribute {
//     name = "package_id"
//     type = "S"
//   }

//   attribute {
//     name = "date_send"
//     type = "S"
//   }

//   attribute {
//     name = "from"
//     type = "S"
//   }

//   attribute {
//     name = "to"
//     type = "S"
//   }


//   attribute {
//     name = "delivery_updates"
//     type = "S"
//   }

//   global_secondary_index {
//     name               = "GameTitleIndex"
//     hash_key           = "GameTitle"
//     range_key          = "TopScore"
//     write_capacity     = 10
//     read_capacity      = 10
//     projection_type    = "INCLUDE"
//     non_key_attributes = ["UserId"]
//   }

//   tags = {
//     Name        = "dynamodb-table-1"
//     Environment = "production"
//   }
// }


# API Endpoint
resource "aws_api_gateway_rest_api" "graphQl_intake" {
  name        = "mlewicki-graphQl-intake"
}

resource "aws_api_gateway_stage" "graphQl_intake_stage" {
  stage_name    = "prod"
  rest_api_id   = "${aws_api_gateway_rest_api.graphQl_intake.id}"
  deployment_id = "${aws_api_gateway_deployment.graphQl_intake_dev.id}"
}




resource "aws_api_gateway_resource" "resource" {
  path_part   = "resource"
  parent_id   = "${aws_api_gateway_rest_api.graphQl_intake.root_resource_id}"
  rest_api_id = "${aws_api_gateway_rest_api.graphQl_intake.id}"
}

resource "aws_api_gateway_method" "method" {
  rest_api_id   = "${aws_api_gateway_rest_api.graphQl_intake.id}"
  resource_id   = "${aws_api_gateway_resource.resource.id}"
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "integration" {
  rest_api_id             = "${aws_api_gateway_rest_api.graphQl_intake.id}"
  resource_id             = "${aws_api_gateway_resource.resource.id}"
  http_method             = "${aws_api_gateway_method.method.http_method}"
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "${aws_lambda_function.handler.invoke_arn}"
}


resource "aws_api_gateway_deployment" "graphQl_intake_dev" {
  depends_on  = ["aws_api_gateway_integration.integration"]
  rest_api_id = "${aws_api_gateway_rest_api.graphQl_intake.id}"
  stage_name  = "dev"
}
