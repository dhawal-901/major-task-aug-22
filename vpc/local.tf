locals {
  config = {
    test = {
      vpc_name        = "vpc_test"
      vpc_cidr        = "10.2.0.0/24"
      public_subnets  = ["10.2.0.0/28", "10.2.0.16/28"]
      private_subnets = ["10.2.0.32/28"]
      azs             = ["ap-south-1a", "ap-south-1b"]
      alb_sg_name     = "alb_sg_test"
      public_sg_name  = "public_sq_test"
      private_sg_name = "private_sq_test"
      alb_name        = "alb-test"

      target_group_1_name = "lg-target-jenkins-test"
      my_certificate_arn = "arn:aws:acm:ap-south-1:905418378622:certificate/b81786bf-840b-440a-a32f-b3aafe124e58"

      my_domains = ["jenkins.test2.dhawal.in.net"]

      public_instance_ami   = "ami-0ad21ae1d0696ad58"
      public_instance_type  = "t2.micro"
      private_instance_ami  = "ami-0ad21ae1d0696ad58"
      private_instance_type = "t2.medium"
    }
  }

  Environment = local.config.test
}
