# Architecture

1. Extraction of YouTube videos' data using python.
2. Load of changed data, using Kafka, to a mongodb cloud database.

Intertwined Confluent Kafka and Mongodb Atlas cloud infrastructure made with Terraform.

# How to use:
[How to use readme](https://github.com/Daesfd/youtube_data_kafka_etl/blob/main/docs/how_to_use.md)

# Limitations/Problems
1. It takes a lot of time to create all the cloud infrastructure, in a way that would be more efficent by doing it manually.
2. For a bigger project, as confluent and mongodb cloud are paid, it would cost some money to run the project.
