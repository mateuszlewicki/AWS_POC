# Specify the provider and access details
provider "aws" {
  #version = "~> 3.0"
  region  = "us-east-1"
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
  name        = "terraform_example_elb"
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
  name = "head_over_to_fabio"

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

resource "aws_key_pair" "auth" {
  key_name   = "${var.key_name}"
  public_key = "${file(var.public_key_path)}"
}

# MACHINES

data "aws_ami" "provision_ami" {
  executable_users = ["self"]
  most_recent      = true
  name_regex       = "^Provision-cluster-*"
  owners           = ["self"]
}

data "aws_ami" "worker_ami" {
  executable_users = ["self"]
  most_recent      = true
  name_regex       = "^nomad-worker-*"
  owners           = ["self"]
}



## NOMAD-CONSUL-VAULT-FABIO
resource "aws_instance" "machine_provision_1"{
 
  connection {
    user = "ec2-user"
  }

  instance_type = "t2.micro"

  ami = "${data.aws_ami.provision_ami.id}"

  key_name = "${aws_key_pair.auth.id}"

  vpc_security_group_ids = ["${aws_security_group.default.id}"]

  subnet_id = "${aws_subnet.default.id}"

  tags = {
    Type = "Quorum"
  }
}

resource "aws_instance" "machine_provision_2"{

  connection {
    user = "ec2-user"
  }

  instance_type = "t2.micro"

  ami = "${data.aws_ami.provision_ami.id}"

  key_name = "${aws_key_pair.auth.id}"

  vpc_security_group_ids = ["${aws_security_group.default.id}"]

  subnet_id = "${aws_subnet.default.id}"

  tags = {
    Type = "Quorum"
  }
}

resource "aws_instance" "machine_provision_3"{

  connection {
    user = "ec2-user"
  }

  instance_type = "t2.micro"

  ami = "${data.aws_ami.provision_ami.id}"

  key_name = "${aws_key_pair.auth.id}"

  vpc_security_group_ids = ["${aws_security_group.default.id}"]

  subnet_id = "${aws_subnet.default.id}"

  tags = {
    Type = "Quorum"
  }
}




## WORKERS (NOMAD_CLIENT + {APACHE OFBIZ, POSTGRESS} / PROMETHEUS-GRAFANA )

resource "aws_instance" "machine_worker_1"{

  connection {
    user = "ec2-user"
  }

  instance_type = "t2.micro"

  ami = "${data.aws_ami.worker_ami.id}"

  key_name = "${aws_key_pair.auth.id}"

  vpc_security_group_ids = ["${aws_security_group.default.id}"]

  subnet_id = "${aws_subnet.default.id}"
}

resource "aws_instance" "machine_worker_2"{

  connection {
    user = "ec2-user"
  }

  instance_type = "t2.micro"

  ami = "${data.aws_ami.worker_ami.id}"

  key_name = "${aws_key_pair.auth.id}"

  vpc_security_group_ids = ["${aws_security_group.default.id}"]

  subnet_id = "${aws_subnet.default.id}"
}

resource "aws_instance" "machine_worker_3"{

  connection {
    user = "ec2-user"
  }

  instance_type = "t2.micro"

  ami = "${data.aws_ami.worker_ami.id}"

  key_name = "${aws_key_pair.auth.id}"

  vpc_security_group_ids = ["${aws_security_group.default.id}"]

  subnet_id = "${aws_subnet.default.id}"
}

# LAMBDAS
 resource "aws_iam_policy" "lambda_all" {
   # ... other configuration ...
   policy = <<POLICY
 {
   "Version": "2012-10-17",
   "Statement": {
     "Effect": "Allow",
     "Action": "*",
     "Resource": "*"
   }
 }
 POLICY
 }
## GRAPHQL ##
resource "aws_lambda_function" "handler"{
  filename= "../Lambdas/Packages/handler.zip"
  function_name="aws_poc_handler"
  role="${aws_iam_role.lambda_all.arn}"
  handler="handler.lambda_handler"
  runtime= "python3.8"
}

## MAIL NOTIFY ##

resource "aws_lambda_function" "sender"{}


## DB INTERACTION ##

resource "aws_lambda_function" "get"{
  filename= "../Lambdas/Packages/get.zip"
  function_name="aws_poc_get"
  role="${aws_iam_role.lambda_all.arn}"
  handler="get.lambda_handler"
  runtime= "python3.8"
}

resource "aws_lambda_function" "post"{
  filename= "../Lambdas/Packages/post.zip"
  function_name="aws_poc_post"
  role="${aws_iam_role.lambda_all.arn}"
  handler="post.lambda_handler"
  runtime= "python3.8"
}

resource "aws_lambda_function" "put"{
  filename= "../Lambdas/Packages/put.zip"
  function_name="aws_poc_put"
  role="${aws_iam_role.lambda_all.arn}"
  handler="put.lambda_handler"
  runtime= "python3.8"
}

resource "aws_lambda_function" "delete"{
  filename= "../Lambdas/Packages/del.zip"
  function_name="aws_poc_del"
  role="${aws_iam_role.lambda_all.arn}"
  handler="delete.lambda_handler"
  runtime= "python3.8"
}


# SES - Simple Email Service

# DynamoDB

# API Endpoint

resource "aws_api_gateway_rest_api" "graphQl_intake" {
  name        = "ServerlessExample"
  description = "Terraform Serverless Application Example"
}


//  resource "aws_api_gateway_resource" "proxy" {
//    rest_api_id = aws_api_gateway_rest_api.graphQl_intake.id
//    parent_id   = aws_api_gateway_rest_api.graphQl_intake.root_resource_id
//    path_part   = "{proxy+}"
// }

// resource "aws_api_gateway_method" "proxy" {
//    rest_api_id   = aws_api_gateway_rest_api.graphQl_intake.id
//    resource_id   = aws_api_gateway_resource.graphQl_intake.id
//    http_method   = "ANY"
//    authorization = "NONE"
//  }

//  resource "aws_api_gateway_integration" "lambda" {
//    rest_api_id = aws_api_gateway_rest_api.graphQl_intake.id
//    resource_id = aws_api_gateway_method.proxy.resource_id
//    http_method = aws_api_gateway_method.proxy.http_method

//    integration_http_method = "POST"
//    type                    = "AWS_PROXY"
//    uri                     = aws_lambda_function.aws_poc_handler.invoke_arn
//  }

//   resource "aws_api_gateway_method" "proxy_root" {
//    rest_api_id   = aws_api_gateway_rest_api.graphQl_intake.id
//    resource_id   = aws_api_gateway_rest_api.graphQl_intake.root_resource_id
//    http_method   = "ANY"
//    authorization = "NONE"
//  }

//  resource "aws_api_gateway_integration" "lambda_root" {
//    rest_api_id = aws_api_gateway_rest_api.graphQl_intake.id
//    resource_id = aws_api_gateway_method.proxy_root.resource_id
//    http_method = aws_api_gateway_method.proxy_root.http_method

//    integration_http_method = "POST"
//    type                    = "AWS_PROXY"
//    uri                     = aws_lambda_function.aws_poc_handler.invoke_arn
//  }

// resource "aws_api_gateway_deployment" "example" {
//    depends_on = [
//      aws_api_gateway_integration.lambda,
//      aws_api_gateway_integration.lambda_root,
//    ]

//    rest_api_id = aws_api_gateway_rest_api.example.id
//    stage_name  = "test"
//  }