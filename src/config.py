import json

with open('../terraform/confluent_kafka/kafka_topic/terraform.tfstate') as terraform_kafka_cluster_output_file:
    kafka_cluster_output = json.load(terraform_kafka_cluster_output_file)

with open('../terraform/confluent_kafka/ksql_cluster/terraform.tfstate') as terraform_ksql_output_file:
    ksql_output = json.load(terraform_ksql_output_file)

config = {'google_api_key': 'Your google API key',
          'youtube_playlist_id': 'PL7sC79uSU_LPgD8X2QvqOI1yxsmEvg2m3',
          'src': {
              'bootstrap.servers': 'pkc-4v5zz.sa-east-1.aws.confluent.cloud:9092',
              'security.protocol': 'sasl_ssl',
              'sasl.mechanism': 'PLAIN',
              'sasl.username': kafka_cluster_output['outputs']['Cluster_api_id']['value'],
              'sasl.password': kafka_cluster_output['outputs']['Cluster_api_secret']['value'],
          },
          'schema_registry': {
              'url': ksql_output['outputs']['Schema_registry_url']['value'],
              'basic.auth.user.info': 'Your schema public key:Your schema secret key'
              # For some reason, the code below, which would tell us the schema registry public and secret key,
              # doesn't work properly. So, I had to do it manually.
              # 'basic.auth.user.info': f"{ksql_output['outputs']['Schema_registry_id']['value']}:{ksql_output['outputs']['Schema_registry_secret']['value']}"

          },
          }
