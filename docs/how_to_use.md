1. With a Mongodb-Atlas account and organisation, create an API Key:
<img src="https://github.com/Daesfd/youtube_data_kafka_etl/blob/main/docs/mongodb_atlas_images/1.png" width="800" height="300">
<img src="https://github.com/Daesfd/youtube_data_kafka_etl/blob/main/docs/mongodb_atlas_images/2.png" width="800" height="300">

2. In Terraform/mongodb_atlas/variables.tf, change the public and private key to the one you got in 1.:
```
variable "mongodb_public_key" {
  type = string
  default = "Your mongodb Atlas public key"
}

variable "mongodb_private_key" {
  type = string
  default = "Your mongodb Atlas private key"
}
```

3. In a Confluent Kafka environment, create an API Key:
<img src="https://github.com/Daesfd/youtube_data_kafka_etl/blob/main/docs/confluent_kafka_images/1.png" width="800" height="300">
<img src="https://github.com/Daesfd/youtube_data_kafka_etl/blob/main/docs/confluent_kafka_images/2.png" width="800" height="300">
<img src="https://github.com/Daesfd/youtube_data_kafka_etl/blob/main/docs/confluent_kafka_images/3.png" width="500" height="300">

4, In Terraform/confluent_kafka/module/variables.tf, change the API key and secret to the one you got in 3.:
```
variable "confluent_cloud_api_key" {
  type = string
  default = "Your confluent api key"
}

variable "confluent_cloud_api_secret" {
  type = string
  default = "Your confluent api secret"
}
```

5. Create, in confluent, a Kafka cluster and get the cluster ID:
<img src="https://github.com/Daesfd/youtube_data_kafka_etl/blob/main/docs/confluent_kafka_images/4.png" width="800" height="300">

6. In Terraform/confluent_kafka/module/variables.tf, put the cluster ID in "confluent_cluster_id":
```
variable "confluent_cluster_id" {
  type = string
  default = "Your confluent cluster id"
}
```

7. In a console, at folder ./Terraform/, initialize and apply all these codes:
```
terraform -chdir=confluent_kafka_module init
terraform -chdir=mongodb_atlas init 
terraform -chdir=confluent_kafka/kafka_topic init
terraform -chdir=confluent_kafka/ksql_cluster init
terraform -chdir=confluent_kafka/mongo_db_connection init

terraform -chdir=confluent_kafka_module apply
terraform -chdir=mongodb_atlas apply 
terraform -chdir=confluent_kafka/kafka_topic apply
terraform -chdir=confluent_kafka/ksql_cluster apply
terraform -chdir=confluent_kafka/mongo_db_connection apply
```

8. Create, in confluent, a schema registry API key:
<img src="https://github.com/Daesfd/youtube_data_kafka_etl/blob/main/docs/confluent_kafka_images/ksql_images/6.png" width="800" height="300">
<img src="https://github.com/Daesfd/youtube_data_kafka_etl/blob/main/docs/confluent_kafka_images/ksql_images/7.png" width="500" height="300">

9. In ./src/config.py, put the schema registry API key in 'basic.auth.user.info'
```
'schema_registry': {
              'url': ksql_output['outputs']['Schema_registry_url']['value'],
              'basic.auth.user.info': 'Your schema public key:Your schema secret key'
          }
```

10. In [confluent site](https://confluent.cloud/home), go to your ksql cluster and put these following codes:
<img src="https://github.com/Daesfd/youtube_data_kafka_etl/blob/main/docs/confluent_kafka_images/ksql_images/1.png" width="300" height="300">
<img src="https://github.com/Daesfd/youtube_data_kafka_etl/blob/main/docs/confluent_kafka_images/ksql_images/2.png" width="300" height="300">
<img src="https://github.com/Daesfd/youtube_data_kafka_etl/blob/main/docs/confluent_kafka_images/ksql_images/3.png" width="300" height="300">
<img src="https://github.com/Daesfd/youtube_data_kafka_etl/blob/main/docs/confluent_kafka_images/ksql_images/4.png" width="500" height="100">
<img src="https://github.com/Daesfd/youtube_data_kafka_etl/blob/main/docs/confluent_kafka_images/ksql_images/5.png" width="300" height="300">

11. In a console, at folder ./, execute twice (in different moments):
```
python ./src/yt_kafka.py
```

# Output
<img src="https://github.com/Daesfd/youtube_data_kafka_etl/blob/main/docs/1.png" width="800" height="300">
