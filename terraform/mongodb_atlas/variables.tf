variable "mongodb_public_key" {
  type = string
  default = "Your mongodb Atlas public key"
}

variable "mongodb_private_key" {
  type = string
  default = "Your mongodb Atlas private key"
}

variable "mongodb_cluster_name" {
  type = string
  default = "yt-stream-cluster"
}

variable "cluster_cloud_type" {
  type = string
  default = "AWS"
}

variable "cluster_size_type" {
  type = string
  default = "M0"
}

variable "region" {
  type = string
  description = "Region for AWS resources."
  default = "SA_EAST_1"
}