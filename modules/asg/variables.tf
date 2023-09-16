variable "project_name" {}
variable "image_id" {
    default = "ami-0f5ee92e2d63afc18"
}
variable "instance_type" {
    default = "t2.micro"
}
variable "key_name" {}
variable "client_sg" {}
variable "max_size" {
    default = 3
}
variable "min_size" {
    default = 1
}
variable "desired_cap" {
    default = 2
}

variable "asg_health_check_type" {
    default = "ELB"
}

variable "pri_sub_3c_id" {}
variable "pri_sub_4d_id" {}
variable "tg_arn" {}