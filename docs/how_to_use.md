1. With a Mongodb-Atlas account and organisation, create an API Key:
<img src="https://github.com/Daesfd/youtube_data_kafka_etl/blob/main/docs/mongodb_atlas_images/1.png" width="800" height="300">
<img src="https://github.com/Daesfd/youtube_data_kafka_etl/blob/main/docs/mongodb_atlas_images/2.png" width="800" height="300">

2. In Terraform/mongodb_atlas/variables.tf, change the public and private key to the one you got in 1.:
'''
variable "mongodb_public_key" {
  type = string
  default = "Your mongodb Atlas public key"
}

variable "mongodb_private_key" {
  type = string
  default = "Your mongodb Atlas private key"
}
'''
