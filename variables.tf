variable "instance_type" {
  description = "Type of EC2 instance to provision"
  default     = "t3.nano"
}

variable "ami_filter" {
    description = "Name Filter and Owner for AMI"

    type = object({
      name  = string
      owner = string
    })

    default = {
    name  = "bitnami-tomcat-*-x86_64-hvm-ebs-nami"
    owner = "979382823631" # Bitnami
  }
}

data "aws_vpc" "default" {
  default = true
}

variable "environment"{
  description = "Development Environment"

  type = object({
    name            = string
    network_prefix  = string
  })

  default = {
  name = "dev"
  network_prefix = "10.0"
  }
  
}

variable "min_size" {
  description = "Minimum number of instances in the ASG"
  default = 1
  }

variable "max_size" {
  description = "Maximum number of instances in the ASG"
  default = 2
  }


/* # commented this code below
resource "aws_instance" "blog" {
  ami                   = data.aws_ami.app_ami.id
  instance_type         = var.instance_type

  subnet_id             = module.blog_vpc.public_subnets[0]
  vpc_security_group_ids = [module.blog_sg.security_group_id]
  
  tags = {
    Name = "HelloWorld" 
  }

}
*/

/* # commented this code below
module "blog_alb" {
  source = "terraform-aws-modules/alb/aws"
  version = "~> 6.0"

  name    = "blog-alb"

  load_balancer_type = "application"

  vpc_id          = module.blog_vpc.vpc_id
  subnets         = module.blog_vpc.public_subnets
  security_groups = [module.blog_sg.security_group_id]

  target_groups = [
    {
      name_prefix      = "blog-"
      backend_protocol = "HTTP" 
      backend_port     = 80
      target_type      = "instance"
      targets = {
        my_target = {
          target_id = aws_instance.blog.id
          port = 80
        }
      }
    }
  ]

  http_tcp_listeners = [
    {
      port               = 80
      protocol           = "HTTP"
      target_group_index = 0
    }
  ]

  tags = {
    Environment = "dev"
  }
}

module "blog_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.3.0"

  vpc_id              = module.blog_vpc.vpc_id
 
  name                = "blog"
  ingress_rules       = ["http-80-tcp", "https-443-tcp"]
  ingress_cidr_blocks = ["0.0.0.0/0"]

  egress_rules       = ["all-all"]
  egress_cidr_blocks = ["0.0.0.0/0"]
}
*/