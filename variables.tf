variable "bastion_instance_types" {
  description = "List of ec2 types for the bastion host, used by aws_launch_template (first from the list) and in aws_autoscaling_group"
  default     = ["t3.small", "t3.medium", "t3.large"]
}

variable "cidr_blocks_whitelist_host" {
  description = "range(s) of incoming IP addresses to whitelist for the HOST"
  type        = list(string)
  default     = []
}

variable "cidr_blocks_whitelist_service" {
  description = "range(s) of incoming IP addresses to whitelist for the SERVICE"
  type        = list(string)
  default     = []
}

variable "environment_name" {
  description = "the name of the environment that we are deploying to, used in tagging. Overwritten if var.service_name and var.bastion_host_name values are changed"
  default     = "staging"
}

variable "vpc" {
  description = "ID for Virtual Private Cloud to apply security policy and deploy stack to"
}

variable "bastion_service_host_key_name" {
  description = "AWS ssh key *.pem to be used for ssh access to the bastion service host"
  default     = ""
}

variable "public_ip" {
  default     = false
  description = "Associate a public IP with the host instance when launching"
}

variable "subnets_lb" {
  type        = list(string)
  description = "list of subnets for load balancer - availability zones must match subnets_asg"
}

variable "subnets_asg" {
  type        = list(string)
  description = "list of subnets for autoscaling group - availability zones must match subnets_lb"
}

variable "dns_domain" {
  description = "The domain used for Route53 records"
  default     = ""
}

variable "route53_zone_id" {
  description = "Route53 zoneId"
  default     = ""
}

variable "bastion_allowed_iam_group" {
  type        = string
  description = "Name IAM group, members of this group will be able to ssh into bastion instances if they have provided ssh key in their profile"
  default     = ""
}

variable "tags" {
  type        = map(string)
  description = "AWS tags that should be associated with created resources"
  default     = {}
}

variable "bastion_host_name" {
  type        = string
  default     = ""
  description = "The hostname to give to the bastion instance"
}

##############################
#LB ASG variables
##############################
variable "lb_healthy_threshold" {
  type        = string
  description = "Healthy threshold for lb target group"
  default     = "2"
}

variable "lb_unhealthy_threshold" {
  type        = string
  description = "Unhealthy threshold for lb target group"
  default     = "2"
}

variable "lb_interval" {
  type        = string
  description = "interval for lb target group health check"
  default     = "30"
}

variable "lb_is_internal" {
  type        = string
  description = "whether the lb will be internal"
  default     = false
}

variable "asg_max" {
  type        = string
  description = "Max numbers of bastion-service hosts in ASG"
  default     = "2"
}

variable "asg_min" {
  type        = string
  description = "Min numbers of bastion-service hosts in ASG"
  default     = "1"
}

variable "asg_desired" {
  type        = string
  description = "Desired numbers of bastion-service hosts in ASG"
  default     = "1"
}

variable "aws_region" {
}

variable "aws_profile" {
  default = ""
}

variable "assume_role_arn" {
  description = "arn for role to assume in separate identity account if used"
  default     = ""
}

variable "lb_healthcheck_port" {
  description = "TCP port to conduct lb target group healthchecks. Acceptable values are 2222 or the value defined for `bastion_service_port`"
  default     = "2222"
}

variable "bastion_vpc_name" {
  description = "define the last part of the hostname, by default this is the vpc ID with magic default value of 'vpc_id' but you can pass a custom string, or an empty value to omit this"
  default     = "vpc_id"
}

variable "container_ubuntu_version" {
  description = "ubuntu version to use for service container"
  default     = "22.04"
}

variable "extra_user_data_content" {
  default     = ""
  description = "Extra user-data to add to the default built-in"
}

variable "extra_user_data_content_type" {
  default     = "text/x-shellscript"
  description = "What format is content in - eg 'text/cloud-config' or 'text/x-shellscript'"
}

variable "extra_user_data_merge_type" {
  # default     = "list(append)+dict(recurse_array)+str()"
  default     = "str(append)"
  description = "Control how cloud-init merges user-data sections"
}

variable "custom_ssh_populate" {
  description = "any value excludes default ssh_populate script used on container launch from userdata"
  default     = ""
}

variable "custom_authorized_keys_command" {
  description = "any value excludes default Go binary iam-authorized-keys built from source from userdata"
  default     = ""
}

variable "custom_docker_setup" {
  description = "any value excludes default docker installation and container build from userdata"
  default     = ""
}

variable "custom_systemd" {
  description = "any value excludes default systemd and hostname change from userdata"
  default     = ""
}

variable "custom_ami_id" {
  description = "id for custom ami if used"
  default     = ""
}

variable "security_groups_additional" {
  description = "additional security group IDs to attach to host instance"
  type        = list(string)
  default     = []
}

variable "service_name" {
  description = "Unique name per vpc for associated resources- set to some non-default value for multiple deployments per vpc"
  default     = "bastion-service"
}

variable "route53_fqdn" {
  description = "If creating a public DNS entry with this module then you may override the default constructed DNS entry by supplying a fully qualified domain name here which will be used verbatim"
  default     = ""
}

variable "on_demand_base_capacity" {
  default     = 0
  description = "allows a base level of on demand when using spot"
}

variable "delete_network_interface_on_termination" {
  description = "if network interface created for bastion host should be deleted when instance in terminated. Setting propagated to aws_launch_template.network_interfaces.delete_on_termination"
  default     = true
}

variable "bastion_ebs_size" {
  description = "Size of EBS attached to the bastion instance"
  default     = 8
}

variable "bastion_ebs_device_name" {
  description = "Name of bastion instance block device"
  default     = "/dev/sda1"
}

variable "autoscaling_group_enabled_metrics" {
  type        = list(string)
  description = "A list of CloudWatch metrics to collect on the autoscaling group. Permitted values include: GroupMinSize; GroupMaxSize; GroupDesiredCapacity; GroupInServiceInstances; GroupPendingInstances; GroupStandbyInstances; GroupTerminatingInstances; GroupTotalInstances"
  default     = []
}

variable "custom_outbound_security_group" {
  type        = bool
  default     = false
  description = "don't create default outgoing permissive security group rule - will only work with custom AMI or if security group supplied with ports 53(UDP); 80(TCP); 443(TCP) open for 0.0.0.0/0 egress"
}

variable "bastion_service_port" {
  type        = number
  description = "Port for containerised ssh daemon"
  default     = 22
}

variable "bastion_metadata_options" {
  type = object({
    http_endpoint               = optional(string)
    http_tokens                 = optional(string)
    http_put_response_hop_limit = optional(number)
    http_protocol_ipv6          = optional(string)
    instance_metadata_tags      = optional(string)
  })
  description = "Passthrough for aws_launch_template.metadata_options. **Don't** apply `http_*` options if you're not sure what you're doing!"
  default     = {}
}
