variable "project"       {}
variable "region"        {}
variable "account_id"    {}
variable "repo_name"     {}
variable "cpu"           { default = "256" }
variable "memory"        { default = "512" }
variable "desired_count" { default = 1 }

variable "private_subnet_ids" {}
variable "ecs_sg_id" {}
variable "target_group_arn" {}
variable "lb_listener" {}
