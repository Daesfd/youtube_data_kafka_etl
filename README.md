# Architecture

1. Extraction of YouTube videos' data using python.
2. Load of changed data, using Kafka, to a mongodb cloud database.

Intertwined Confluent Kafka and Mongodb Atlas cloud infrastructure made with Terraform.

# How to use:
[How to use readme](https://github.com/Daesfd/youtube_data_kafka_etl/blob/main/docs/how_to_use.md)

# Limitations/Problems
1. For some reason, by using Terraform to create the infrastructure for both confluent and mongodb atlas, it returns that the regions aren't the same, even though they are.
2. The schema registry API key, which you can get at ./terraform/confluent_kafka/ksql_cluster/terraform.tfstate, doesn't work properly, in a way that you need to get the key manually.
3. It takes a lot of time to create all the cloud infrastructure, in a way that would be more efficent by doing it manually.
4. For a bigger project, as confluent and mongodb cloud are paid, it would cost some money to run the project.
